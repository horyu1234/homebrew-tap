#!/usr/bin/env python3
"""Bump formulae that install GitHub release assets to the latest release.

A formula takes part when its urls point at
https://github.com/<owner>/<repo>/releases/download/<tag>/<asset> and the
release also carries a SHA256SUMS file listing every asset. Asset names are
expected to contain the tag (e.g. routebox-v0.3.1-darwin-arm64.tar.gz), so the
new names are the old ones with the tag swapped.

Usage: bump-formula.py [formula ...]   (default: every Formula/*.rb)
Writes changed=<names> and <name>=<version> to $GITHUB_OUTPUT when set.
"""
import os
import pathlib
import re
import subprocess
import sys

URL_RE = re.compile(r'url "https://github\.com/([^/"]+/[^/"]+)/releases/download/([^/"]+)/([^"]+)"')
SHA_RE = re.compile(r'sha256 "[0-9a-f]{64}"')


def gh(*args):
    return subprocess.run(["gh", *args], check=True, capture_output=True, text=True).stdout


def bump(path):
    text = path.read_text()
    urls = URL_RE.findall(text)
    if not urls:
        print(f"{path.stem}: no release asset urls, skipped")
        return None
    repos = {r for r, _, _ in urls}
    tags = {t for _, t, _ in urls}
    if len(repos) != 1 or len(tags) != 1:
        sys.exit(f"{path.stem}: urls must share one repo and one tag, got {repos} {tags}")
    repo, old = repos.pop(), tags.pop()
    new = gh("release", "view", "-R", repo, "--json", "tagName", "-q", ".tagName").strip()
    if new == old:
        print(f"{path.stem}: up to date at {old}")
        return None

    sums = {}
    for line in gh("release", "download", new, "-R", repo, "-p", "SHA256SUMS", "-O", "-").splitlines():
        parts = line.split()
        if len(parts) == 2:
            sums[parts[1].lstrip("*")] = parts[0]

    out, pos = [], 0
    for m in URL_RE.finditer(text):
        asset = m.group(3).replace(old, new)
        if asset not in sums:
            sys.exit(f"{path.stem}: {asset} is not in {repo} {new} SHA256SUMS")
        sha = SHA_RE.search(text, m.end())
        # 이 url 바로 다음 sha256 이어야 한다: 사이에 다른 url 이 끼면 짝이 틀린 것이다.
        if not sha or URL_RE.search(text, m.end(), sha.start()):
            sys.exit(f"{path.stem}: no sha256 right after {m.group(0)}")
        out.append(text[pos:m.start()])
        out.append(f'url "https://github.com/{repo}/releases/download/{new}/{asset}"')
        out.append(text[m.end():sha.start()])
        out.append(f'sha256 "{sums[asset]}"')
        pos = sha.end()
    out.append(text[pos:])
    path.write_text("".join(out))
    version = new.removeprefix("v")
    print(f"{path.stem}: {old} -> {new}")
    return version


def main():
    names = sys.argv[1:]
    paths = [pathlib.Path("Formula", f"{n}.rb") for n in names] or sorted(pathlib.Path("Formula").glob("*.rb"))
    changed = {}
    for p in paths:
        if not p.exists():
            sys.exit(f"{p} does not exist")
        v = bump(p)
        if v:
            changed[p.stem] = v
    if out := os.environ.get("GITHUB_OUTPUT"):
        with open(out, "a") as f:
            f.write(f"changed={' '.join(changed)}\n")
            f.write(f"message={', '.join(f'{n} {v}' for n, v in changed.items())}\n")


if __name__ == "__main__":
    main()

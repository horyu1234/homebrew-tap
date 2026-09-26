# horyu1234/tap

Homebrew tap for tools by [@horyu1234](https://github.com/horyu1234).

```sh
brew tap horyu1234/tap
brew install <formula>
# or in one step
brew install horyu1234/tap/<formula>
```

## Formulae

| Formula | Description | Install |
|---|---|---|
| [routebox](Formula/routebox.rb) | Local HTTP proxy with a terminal UI that sends chosen domains through chosen SSH/SOCKS5 tunnels ([route-box](https://github.com/horyu1234/route-box)) | `brew install horyu1234/tap/routebox` |

Formulae install the prebuilt binaries attached to each project's GitHub release, so no toolchain (Go, Rust, …) is needed.

## Updates are automatic

[`update-formulae`](.github/workflows/update-formulae.yml) runs every hour. For each formula it checks the latest GitHub release of the project, rewrites every `url`/`sha256` pair from that release's `SHA256SUMS`, and commits the bump only after `brew style`, `brew audit --strict --online`, `brew install` and `brew test` pass on macOS.

A project can trigger it right after publishing a release instead of waiting for the hour:

```sh
gh workflow run update-formulae.yml -R horyu1234/homebrew-tap -f formula=<name>
```

(from a workflow, with a fine-grained token that has **Actions: read and write** on this repository only). Run it by hand with `-f verify=true` to re-check the current formulae without a new release.

## Adding a formula

1. Publish releases in the project's repository with one `<name>-<tag>-<os>-<arch>.tar.gz` per platform (the tag must appear in the file name) and a `SHA256SUMS` file listing them.
2. Add `Formula/<name>.rb` with an `on_macos`/`on_linux` × `on_arm`/`on_intel` `url` under `…/releases/download/<tag>/`, each followed by its `sha256`, plus `bin.install` and a `test do` block that runs the binary.
3. Check it locally:

   ```sh
   brew style horyu1234/tap/<name>
   brew audit --strict --online horyu1234/tap/<name>
   brew reinstall horyu1234/tap/<name> && brew test horyu1234/tap/<name>
   ```

4. Add a row to the table above. From then on the workflow keeps it current.

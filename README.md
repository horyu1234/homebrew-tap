# horyu1234/tap

Homebrew formulae for [RouteBox](https://github.com/horyu1234/route-box).

```sh
brew install horyu1234/tap/routebox
```

Formulae build from the tagged source release with Go, so nothing unsigned is downloaded.

## Updating a formula after a release

```sh
url=https://github.com/horyu1234/route-box/archive/refs/tags/vX.Y.Z.tar.gz
curl -sL "$url" | shasum -a 256   # new sha256
```

Update `url` and `sha256` in `Formula/routebox.rb`, then check it:

```sh
brew audit --strict --online horyu1234/tap/routebox
brew install --build-from-source horyu1234/tap/routebox && brew test routebox
```

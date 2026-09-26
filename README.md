# horyu1234/tap

Homebrew formulae for [RouteBox](https://github.com/horyu1234/route-box), a local HTTP proxy with a terminal UI that sends the domains you choose through the SSH/SOCKS5 tunnels you choose.

```sh
brew install horyu1234/tap/routebox
```

The formula installs the prebuilt binary attached to the [GitHub release](https://github.com/horyu1234/route-box/releases) for macOS and Linux (arm64, x86_64). Go is not needed.

## Updating the formula after a release

Pushing a `vX.Y.Z` tag to route-box builds the release binaries and a `SHA256SUMS` file. Then:

```sh
gh release download vX.Y.Z -R horyu1234/route-box -p SHA256SUMS -O - # four sha256 values
```

Set the four `url`/`sha256` pairs in `Formula/routebox.rb`, then check it:

```sh
brew audit --strict --online horyu1234/tap/routebox
brew reinstall horyu1234/tap/routebox && brew test routebox
```

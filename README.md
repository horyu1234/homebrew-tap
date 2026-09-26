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

## Adding or updating a formula

1. Publish a release in the project's repository with one archive per platform and a `SHA256SUMS` file.
2. Add or edit `Formula/<name>.rb`: an `on_macos`/`on_linux` × `on_arm`/`on_intel` `url` + `sha256` for each archive, `bin.install`, and a `test do` block that runs the binary.
3. Check it:

   ```sh
   brew style horyu1234/tap/<name>
   brew audit --strict --online horyu1234/tap/<name>
   brew reinstall horyu1234/tap/<name> && brew test horyu1234/tap/<name>
   ```

4. Add a row to the table above.

To bump a version, download the new `SHA256SUMS` (e.g. `gh release download vX.Y.Z -R horyu1234/<repo> -p SHA256SUMS -O -`) and replace every `url`/`sha256` pair.

class Routebox < Formula
  desc "Selective tunnel router: send chosen domains through chosen SSH/SOCKS tunnels"
  homepage "https://github.com/horyu1234/route-box"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/horyu1234/route-box/releases/download/v0.3.2/routebox-v0.3.2-darwin-arm64.tar.gz"
      sha256 "344a3720d0ffac769fdb574a5afdc20f161e91c5a42255a3c01e87f2354d7baf"
    end
    on_intel do
      url "https://github.com/horyu1234/route-box/releases/download/v0.3.2/routebox-v0.3.2-darwin-amd64.tar.gz"
      sha256 "3a9f7242277c84f6b20885b5e38cd8e4377fee478141c6277e33e14194f2b110"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/horyu1234/route-box/releases/download/v0.3.2/routebox-v0.3.2-linux-arm64.tar.gz"
      sha256 "456a89741fa2368b152f6c84f0bfe229b194c67236041fb39ccd753d60a19787"
    end
    on_intel do
      url "https://github.com/horyu1234/route-box/releases/download/v0.3.2/routebox-v0.3.2-linux-amd64.tar.gz"
      sha256 "fa41a16139a554307caf910c05938e0902af06a693dc8c334ceca8f4d5e9812b"
    end
  end

  def install
    bin.install "routebox"
  end

  def caveats
    <<~EOS
      To start RouteBox at login and keep it running in the background:
        routebox service install
      After `brew upgrade routebox`, restart it to pick up the new version:
        routebox service restart
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/routebox --version")

    (testpath/"config.json").write "{}"
    system bin/"routebox", "--config", testpath/"config.json", "route", "add", "*.example.com", "--via", "direct"
    assert_match "*.example.com", shell_output("#{bin}/routebox --config #{testpath}/config.json route list")
  end
end

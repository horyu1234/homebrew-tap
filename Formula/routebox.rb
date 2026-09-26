class Routebox < Formula
  desc "Selective tunnel router: send chosen domains through chosen SSH/SOCKS tunnels"
  homepage "https://github.com/horyu1234/route-box"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/horyu1234/route-box/releases/download/v0.3.1/routebox-v0.3.1-darwin-arm64.tar.gz"
      sha256 "0f1dfd31c138f567436526874b35493fad53e4331946617e28e9732d7af9d152"
    end
    on_intel do
      url "https://github.com/horyu1234/route-box/releases/download/v0.3.1/routebox-v0.3.1-darwin-amd64.tar.gz"
      sha256 "079720312cda7f4dce342cc58a16cf68c3d020f41fb69dc8d4a5076c5190f371"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/horyu1234/route-box/releases/download/v0.3.1/routebox-v0.3.1-linux-arm64.tar.gz"
      sha256 "d9634c4a8c2ad84e5c9047c5cfac6ec88c82801e0c93363e1e2b4c5ad33387ae"
    end
    on_intel do
      url "https://github.com/horyu1234/route-box/releases/download/v0.3.1/routebox-v0.3.1-linux-amd64.tar.gz"
      sha256 "6b114c5b37b6de6ab4c3b7f995e852b627bb1e3ce41bc1d49b7a6dbe06465c12"
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

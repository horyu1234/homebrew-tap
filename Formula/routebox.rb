class Routebox < Formula
  desc "Selective tunnel router: send chosen domains through chosen SSH/SOCKS tunnels"
  homepage "https://github.com/horyu1234/route-box"
  url "https://github.com/horyu1234/route-box/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d77aede19fcbec006f9d059e14d61797940a72cdada0c6c147083a72bd5c5cf9"
  license "MIT"
  head "https://github.com/horyu1234/route-box.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/routebox"
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

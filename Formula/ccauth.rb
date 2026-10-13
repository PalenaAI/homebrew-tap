# Template for the Homebrew formula published to PalenaAI/homebrew-tap.
# .github/workflows/release.yml renders it with render-formula.sh on each tag: it
# fills in the version and sha256, adds bottles built on CI runners, and pushes
# the result to the tap. Bottles mean users never build locally, so installs
# work regardless of the user's Command Line Tools or macOS version. The source
# build stays as the fallback for platforms without a bottle.
class Ccauth < Formula
  desc "OAuth2/SSO credential helper for Claude Code and AI gateways"
  homepage "https://github.com/PalenaAI/claude-code-auth-helper"
  url "https://github.com/PalenaAI/claude-code-auth-helper/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "8de59bdcd691eff7deceae854287ba31fa5bd5296750bb47bd382bd804aa7d31"
  license "Apache-2.0"
  head "https://github.com/PalenaAI/claude-code-auth-helper.git", branch: "main"

  bottle do
    root_url "https://github.com/PalenaAI/claude-code-auth-helper/releases/download/v1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc61cbaa9e97d2ebded88963359d654e68a43e1979416417a99d66be87f56fee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7336e0bef046ce3b458ebfb0766c9980de15a24e516c56050e334cf2dcaff9d"
    sha256 cellar: :any,                 x86_64_linux:  "a392f2035d5257f056eb2668e2a77348dcdbf3fd13ab4079fafdd57dd8cb1b06"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/ccauth"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccauth --version")
  end
end

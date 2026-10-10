# Template for the Homebrew formula published to PalenaAI/homebrew-tap.
# .github/workflows/release.yml renders it with render-formula.sh on each tag: it
# fills in the version and sha256, adds bottles built on CI runners, and pushes
# the result to the tap. Bottles mean users never build locally, so installs
# work regardless of the user's Command Line Tools or macOS version. The source
# build stays as the fallback for platforms without a bottle.
class Ccauth < Formula
  desc "OAuth2/SSO credential helper for Claude Code and AI gateways"
  homepage "https://github.com/PalenaAI/claude-code-auth-helper"
  url "https://github.com/PalenaAI/claude-code-auth-helper/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "3538f43c07fa77e5405e4548350c0cc5837ecd37269892e4452d6de1c501e455"
  license "Apache-2.0"
  head "https://github.com/PalenaAI/claude-code-auth-helper.git", branch: "main"

  bottle do
    root_url "https://github.com/PalenaAI/claude-code-auth-helper/releases/download/v0.1.3"
    sha256 cellar: "any_skip_relocation", arm64_sequoia: "96cff7f5fd39aa202062ec6ba9c6778a9ddd2ed720659ecc13c487270b6ec2f1"
    sha256 cellar: "any_skip_relocation", arm64_linux:   "318ef754fb89420805f3e15acb4fd7dc9d4dce16b46d3dc0093f9f13df284a15"
    sha256 cellar: "any",                 x86_64_linux:  "5d8f5328b620326ad35a7a11955d0006bd733fd2794ff31d5cefdf80465ea60a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/ccauth"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccauth --version")
  end
end

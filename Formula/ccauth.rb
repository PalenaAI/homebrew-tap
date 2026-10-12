# Template for the Homebrew formula published to PalenaAI/homebrew-tap.
# .github/workflows/release.yml renders it with render-formula.sh on each tag: it
# fills in the version and sha256, adds bottles built on CI runners, and pushes
# the result to the tap. Bottles mean users never build locally, so installs
# work regardless of the user's Command Line Tools or macOS version. The source
# build stays as the fallback for platforms without a bottle.
class Ccauth < Formula
  desc "OAuth2/SSO credential helper for Claude Code and AI gateways"
  homepage "https://github.com/PalenaAI/claude-code-auth-helper"
  url "https://github.com/PalenaAI/claude-code-auth-helper/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "f636160cd4ba29b1384dab39b6599429331d9b2903f383fd502632120c7d78d7"
  license "Apache-2.0"
  head "https://github.com/PalenaAI/claude-code-auth-helper.git", branch: "main"

  bottle do
    root_url "https://github.com/PalenaAI/claude-code-auth-helper/releases/download/v0.1.4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa5e13e34a531ab58b30829016d9916b436365b84719bfe5381d97b8566322a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60687b5099d3060b08ae85d9c52830a061a09ff545c7433d7672cda5886493b3"
    sha256 cellar: :any,                 x86_64_linux:  "67b5a7cea279b914a353a829043224fc4636a5d52cbd2ee39c9a7190074db93a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/ccauth"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccauth --version")
  end
end

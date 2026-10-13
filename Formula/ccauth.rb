# Template for the Homebrew formula published to PalenaAI/homebrew-tap.
# .github/workflows/release.yml renders it with render-formula.sh on each tag: it
# fills in the version and sha256, adds bottles built on CI runners, and pushes
# the result to the tap. Bottles mean users never build locally, so installs
# work regardless of the user's Command Line Tools or macOS version. The source
# build stays as the fallback for platforms without a bottle.
class Ccauth < Formula
  desc "OAuth2/SSO credential helper for Claude Code and AI gateways"
  homepage "https://github.com/PalenaAI/claude-code-auth-helper"
  url "https://github.com/PalenaAI/claude-code-auth-helper/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3d6502628ca91c6a88bfc4edffb89490f753a88d6adcec05a4582d2fd105a508"
  license "Apache-2.0"
  head "https://github.com/PalenaAI/claude-code-auth-helper.git", branch: "main"

  bottle do
    root_url "https://github.com/PalenaAI/claude-code-auth-helper/releases/download/v0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b887a6eb261ede7052ff8cc4442b341b77c577d06edf7a5dd6b0052825ef2c93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1f46dadf10d693358faaf749407a4f79b8b40926d798b1dac747a3745a674e3"
    sha256 cellar: :any,                 x86_64_linux:  "aaac719bace9f125a185c3369186e0e894cb6ce22af8a7a8b7a23d608dfb0e3e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/ccauth"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccauth --version")
  end
end

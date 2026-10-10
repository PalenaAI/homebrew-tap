# PalenaAI Homebrew Tap

[Homebrew](https://brew.sh) formulae for PalenaAI's SSO credential helpers for AI
coding agents. Each helper signs you in with your corporate identity (Microsoft
Entra ID, Google Workspace, or any OIDC provider) and hands the agent a
short-lived token for your AI gateway, so nobody has to manage API keys by hand.

Works on **macOS** (Apple silicon and Intel) and **Linux** (Homebrew on Linux).

## Formulae

| Formula | For | Install | Project |
| --- | --- | --- | --- |
| `ccauth` | Claude Code | `brew install PalenaAI/tap/ccauth` | [claude-code-auth-helper](https://github.com/PalenaAI/claude-code-auth-helper) |
| `cxauth` | OpenAI Codex CLI | `brew install PalenaAI/tap/cxauth` | [codex-auth-helper](https://github.com/PalenaAI/codex-auth-helper) |
| `gbauth` | Grok Build | `brew install PalenaAI/tap/gbauth` | [grok-build-auth-helper](https://github.com/PalenaAI/grok-build-auth-helper) |

## Install

Install a helper directly. Homebrew adds the tap automatically:

```bash
brew install PalenaAI/tap/ccauth
```

Or add the tap once and use the short names:

```bash
brew tap PalenaAI/tap
brew install ccauth cxauth gbauth   # pick the ones you need
```

Check it worked:

```bash
ccauth --version
```

Then follow the project's README to sign in and connect the helper to your agent.
For example, run `ccauth setup` for Claude Code.

## Upgrade and uninstall

```bash
brew update && brew upgrade ccauth   # get the latest release
brew uninstall ccauth                # remove the helper
brew untap PalenaAI/tap              # remove the tap once no helpers remain
```

Uninstalling removes the binary only. Your helper config (for example
`~/.config/ccauth/`) and the session stored in your OS keychain stay until you
run the helper's `logout` command or delete them yourself.

## How these formulae work

- **Prebuilt bottles.** Each release ships Homebrew bottles for macOS (Apple
  silicon and Intel) and Linux (x86_64 and arm64), built and tested on GitHub
  Actions. The macOS bottles are built on macOS 15 and Homebrew uses them on 15,
  26 and 27. You don't need Xcode, the Command Line Tools or Go to install.
- **Source build as a fallback.** On a platform without a bottle, Homebrew builds
  from the tagged source with Go. That needs Command Line Tools that match your
  macOS. Bottles are formula installs, so macOS Gatekeeper doesn't quarantine
  them either way.
- **Pinned and checksummed.** Each formula points at one release tag with its
  SHA-256.
- **Updated automatically.** When a project tags a release (`v*`), its release
  workflow renders the formula and commits it here. A new version is normally
  available a few minutes after the GitHub release appears.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `Error: No available formula` | Run `brew update`. If the release is brand new, wait until its workflow has finished. |
| `Your Command Line Tools (CLT) does not support macOS …` | Homebrew is building from source because no bottle matched. Run `brew update` to get the formula with bottles. If it persists, update the Command Line Tools from Software Update, or reinstall them with `sudo rm -rf /Library/Developer/CommandLineTools && xcode-select --install`. |
| Build fails on `go` | Only happens on a source build. Run `brew update && brew upgrade go`. |
| Old version after upgrading | Run `brew update` first so Homebrew fetches the latest formulae from the tap. |
| `ccauth: command not found` | Make sure Homebrew's `bin` is on your `PATH` (`brew --prefix`/bin). |

Report bugs in the helper itself in its own repository (links above). Report
security issues through each project's `SECURITY.md`, not in public issues.

---

## For maintainers

Don't edit the files in `Formula/` by hand: each release overwrites them. The
source of truth is the template in each project:

| Formula | Template | Written by |
| --- | --- | --- |
| `Formula/ccauth.rb` | `claude-code-auth-helper/packaging/homebrew/ccauth.rb` | that repo's `release.yml` → `homebrew` job |
| `Formula/cxauth.rb` | `codex-auth-helper/packaging/homebrew/cxauth.rb` | that repo's `release.yml` → `homebrew` job |
| `Formula/gbauth.rb` | `grok-build-auth-helper/packaging/homebrew/gbauth.rb` | that repo's `release.yml` → `homebrew` job |

On a tag push, the release workflow:

1. **`bottles`** (matrix: `macos-15`, `macos-15-intel`, `ubuntu-24.04`,
   `ubuntu-24.04-arm`): renders the formula into a local `palenaai/tap`, runs
   `brew install --build-bottle`, `brew test` and `brew bottle`, and attaches the
   bottle to the GitHub release;
2. **`homebrew`**: renders the formula (`packaging/homebrew/render-formula.sh`)
   with the source SHA-256 and a `bottle do` block for every bottle that was
   built, and commits `Formula/<name>.rb` here as `github-actions[bot]`.

A failed bottle doesn't block publishing; that platform falls back to a source
build. To rebuild bottles for an existing release, run the project's `release`
workflow manually and pass the tag.

**Access.** Each project repo needs a `HOMEBREW_TAP_TOKEN` secret. Use a
fine-grained token whose resource owner is PalenaAI, limited to this repository,
with *Contents: read and write*. Without the secret, the job skips the tap update
and the release still succeeds. When the token expires, rotate it in all three
repos.

**Fixing a formula.** Change the template in the project, then cut a patch
release. For an urgent fix without a release, edit the file here; the next
release replaces it.

**Testing a change locally** before releasing:

```bash
brew tap PalenaAI/tap "$PWD"          # tap this local checkout
brew install --build-from-source PalenaAI/tap/ccauth
brew test PalenaAI/tap/ccauth
brew audit --strict PalenaAI/tap/ccauth
brew uninstall ccauth && brew untap PalenaAI/tap
```

**Adding a new helper.**

1. Add `packaging/homebrew/<name>.rb` and the `homebrew` job, copied from an
   existing project.
2. Set `HOMEBREW_TAP_TOKEN` in the new repo.
3. Add a row to both tables in this README.

# Homebrew formula for HnsX.
#
# Two install modes:
#
#   brew install narcilee7/hnsx/hnsx          # stable: download pre-built
#                                             # binaries from the v1.0.0
#                                             # GitHub Release, verify
#                                             # against pinned sha256.
#   brew install --HEAD narcilee7/hnsx/hnsx  # HEAD: clone main + run
#                                             # `make build-cli/build-server`
#                                             # locally (needs Go 1.22+).
#
# When cutting a new release:
#   1. Bump `version` and the four sha256 values below.
#   2. Pull them from the release's `checksums.txt`.
#   3. Push a new commit to this tap.
class Hnsx < Formula
  desc "Operator CLI for the HnsX Harness-as-a-Service platform"
  homepage "https://hnsx.dev"
  version "1.0.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/narcilee7/HnsX/releases/download/v#{version}/hnsx_darwin_arm64.tar.gz"
      sha256 "289c5dcce0809b7197df8cb39feaa74139d937497dc1f4be39dbc057dde73a65"
    elsif Hardware::CPU.intel?
      url "https://github.com/narcilee7/HnsX/releases/download/v#{version}/hnsx_darwin_amd64.tar.gz"
      sha256 "040a8d91919275232047386502af954b9473d3bc1ec6f3cd78a4a66b348ce123"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/narcilee7/HnsX/releases/download/v#{version}/hnsx_linux_arm64.tar.gz"
      sha256 "20cc152b9d2a6294a0aac7415f390c9bb3da33e3459e0c8e21c0f94f184e27ca"
    elsif Hardware::CPU.intel?
      url "https://github.com/narcilee7/HnsX/releases/download/v#{version}/hnsx_linux_amd64.tar.gz"
      sha256 "667356513a8c0fc307ca80ba799fb8f6c1685bd109ba1bab43945aae16a608d5"
    end
  end

  head "https://github.com/narcilee7/HnsX.git", branch: "main"

  depends_on "go" => :build

  def install
    if build.head?
      system "make", "build-cli"
      system "make", "build-server"
    end
    bin.install "hnsx"
    bin.install "hnsx-server"
  end

  test do
    assert_predicate bin/"hnsx", :exist?
    assert_predicate bin/"hnsx-server", :exist?
    assert_match "hnsx", shell_output("#{bin}/hnsx version")
  end
end
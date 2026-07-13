# Homebrew formula for HnsX (HEAD build).
#
# Source lives at https://github.com/narcilee7/HnsX. Until the first stable
# release is published, install from git HEAD via:
#
#   brew install --HEAD narcilee7/hnsx/hnsx
#
# Once `narcilee7/HnsX` ships a GitHub release with `hnsx_<os>_<arch>.tar.gz`
# + `checksums.txt`, this formula should grow a stable `url` / `sha256` /
# `version` block and drop the head-only constraint.
class Hnsx < Formula
  desc "Operator CLI for the HnsX Harness-as-a-Service platform"
  homepage "https://hnsx.dev"
  head "https://github.com/narcilee7/HnsX.git"

  depends_on "go" => :build

  def install
    system "make", "build-cli"
    system "make", "build-server"
    bin.install "bin/hnsx"
    bin.install "bin/hnsx-server"
  end

  test do
    assert_predicate bin/"hnsx", :exist?
    assert_predicate bin/"hnsx-server", :exist?
    assert_match "hnsx", shell_output("#{bin}/hnsx version")
  end
end
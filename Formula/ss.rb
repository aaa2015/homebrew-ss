# Homebrew Formula for ss
# Socket Statistics tool for macOS (Linux ss command clone)

class Ss < Formula
  desc "Socket statistics tool for macOS (Linux ss command clone)"
  homepage "https://github.com/aaa2015/myiosss"
  url "https://github.com/aaa2015/myiosss/archive/v1.0.1.tar.gz"
  sha256 "3110ca6db1d5c1928073fc8a18fb6ad368c61be34c42fa8be5492ca1d3ec9ba8"
  license "MIT"
  version "1.0.1"

  depends_on :macos

  def install
    system "make", "macos"
    bin.install "build/ss"
  end

  test do
    assert_match "ss (Darwin) version", shell_output("#{bin}/ss -V")
  end
end

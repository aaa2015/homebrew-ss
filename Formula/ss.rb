# Homebrew Formula for ss
# Socket Statistics tool for macOS (Linux ss command clone)

class Ss < Formula
  desc "Socket statistics tool for macOS (Linux ss command clone)"
  homepage "https://github.com/aaa2015/myiosss"
  url "https://github.com/aaa2015/myiosss/archive/v1.0.1.tar.gz"
  sha256 "2696a0a7f949d892e9b2a59a34ef773bf1fd1bc4c74961c498e6656f6c652d1e"
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

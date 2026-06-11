# Homebrew Formula for myss
# Socket Statistics tool for macOS (Linux ss command clone)
#
# To use this formula:
# 1. Use your existing GitHub repo named "homebrew-ss"
# 2. Create Formula/ directory in that repo (if not already existing)
# 3. Copy this file to Formula/myss.rb
# 4. Users can then install with: brew tap aaa2015/ss && brew install myss

class Myss < Formula
  desc "Socket statistics tool for macOS (Linux ss command clone)"
  homepage "https://github.com/aaa2015/myiosss"
  url "https://github.com/aaa2015/myiosss/archive/v1.0.1.tar.gz"
  sha256 "2696a0a7f949d892e9b2a59a34ef773bf1fd1bc4c74961c498e6656f6c652d1e"
  license "MIT"
  version "1.0.1"

  depends_on :macos

  def install
    system "make", "macos"
    bin.install "build/ss" => "myss"
  end

  test do
    assert_match "ss (Darwin) version", shell_output("#{bin}/myss -V")
  end
end

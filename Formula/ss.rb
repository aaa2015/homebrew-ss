# Homebrew Formula for ss
# Socket Statistics tool for macOS (Linux ss command clone)

class Ss < Formula
  desc "Socket statistics tool for macOS (Linux ss command clone)"
  homepage "https://github.com/aaa2015/myiosss"
  url "https://github.com/aaa2015/myiosss/archive/v1.0.0.tar.gz"
  sha256 "b01a18bda6c4d56dd3e914e8ff06abf67fbd73575b3e74f47c4b08eb3b85bf68"
  license "MIT"
  version "1.0.0"

  depends_on :macos

  def install
    system "make", "macos"
    bin.install "build/ss"
  end

  test do
    assert_match "ss (Darwin) version", shell_output("#{bin}/ss -V")
  end
end

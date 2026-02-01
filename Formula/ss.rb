# Homebrew Formula for ss
# Socket Statistics tool for macOS (Linux ss command clone)

class Ss < Formula
  desc "Socket statistics tool for macOS (Linux ss command clone)"
  homepage "https://github.com/aaa2015/myiosss"
  url "https://github.com/aaa2015/myiosss/archive/v1.0.1.tar.gz"
  sha256 "785d98490cd78dcb56b0d7240e8de19594f1de8671a3e159fff5729a6406b2ab"
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

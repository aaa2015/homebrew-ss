# Homebrew Formula for mycode
# AI coding assistant with TUI interface
#
# Install:  brew tap aaa2015/ss && brew install mycode
# Upgrade:  brew upgrade mycode

class Mycode < Formula
  desc "AI coding assistant with TUI interface"
  homepage "https://github.com/aaa2015/mycode"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/aaa2015/mycode/releases/download/v#{version}/mycode-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "cc26600ff8e1fdedd5749420994f55329daecc6e6ee0d2e97504373a93ff65f5"
    end
  end

  def install
    bin.install "mycode"
    bin.install "mycode-gateway"
    (share/"mycode").install "config.example.yaml"
  end

  def caveats
    <<~EOS
      To get started, create a config file:
        mkdir -p ~/.config/mycode
        cp #{share}/mycode/config.example.yaml ~/.config/mycode/config.yaml

      Then edit ~/.config/mycode/config.yaml with your API keys.

      Environment variables:
        export DEEPSEEK_API_KEY="your-key"
        export GEMINI_API_KEY="your-key"
    EOS
  end

  test do
    assert_match "mycode", shell_output("#{bin}/mycode --help")
  end
end

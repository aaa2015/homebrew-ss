# Homebrew Formula for mycode
# AI coding assistant with TUI interface
#
# Install:  brew tap aaa2015/ss && brew install mycode
# Upgrade:  brew upgrade mycode

require "download_strategy"

class GitHubPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
  end

  def parse_url_pattern
    url_pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Release."
    end
    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
  end

  def download_url
    "https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    token = ENV["HOMEBREW_GITHUB_API_TOKEN"] || ENV["GITHUB_TOKEN"]
    raise CurlDownloadStrategyError, "HOMEBREW_GITHUB_API_TOKEN or GITHUB_TOKEN is required to download this private release." if token.nil? || token.empty?

    # Download via Curl using GitHub API
    curl_download download_url,
                  "--header", "Authorization: token #{token}",
                  "--header", "Accept: application/octet-stream",
                  to: temporary_path,
                  timeout: timeout
  end

  def asset_id
    token = ENV["HOMEBREW_GITHUB_API_TOKEN"] || ENV["GITHUB_TOKEN"]
    raise CurlDownloadStrategyError, "HOMEBREW_GITHUB_API_TOKEN or GITHUB_TOKEN is required to download this private release." if token.nil? || token.empty?

    # Fetch release metadata from GitHub API
    headers = ["--header", "Authorization: token #{token}"]
    api_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
    
    # We use Homebrew's built-in curl to fetch the JSON metadata
    output, _, status = curl_output(api_url, *headers, timeout: 30)
    raise CurlDownloadStrategyError, "Failed to fetch release metadata: status #{status}" unless status.success?

    # Parse JSON and find asset ID
    require "json"
    begin
      release = JSON.parse(output)
      if release.key?("message")
        raise CurlDownloadStrategyError, "GitHub API error: '#{release["message"]}'. Please verify your HOMEBREW_GITHUB_API_TOKEN is valid and has 'repo' scope."
      end
      assets = release["assets"] || []
      asset = assets.find { |a| a["name"] == @filename }
      raise CurlDownloadStrategyError, "Asset #{@filename} not found in release #{@tag}." if asset.nil?
      asset["id"]
    rescue JSON::ParserError => e
      raise CurlDownloadStrategyError, "Failed to parse release metadata JSON: #{e.message}. Raw output: #{output}"
    end
  end
end

class Mycode < Formula
  desc "AI coding assistant with TUI interface"
  homepage "https://github.com/aaa2015/mycode"
  version "0.1.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/aaa2015/mycode/releases/download/#{version}/mycode-#{version}-aarch64-apple-darwin.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "dac8345072d9a6fc98348036cc711dc4a6ce25565d3debb583c7aefb11a1538a"
    end
  end

  def install
    bin.install "mycode"
    bin.install "mycode-gateway"
    bin.install "scripts/mycode-setup-codesign"
    (share/"mycode").install "config.example.yaml"
  end

  def post_install
    if OS.mac?
      cert_output = `security find-certificate -c mycodecodesign 2>/dev/null || true`
      if !cert_output.strip.empty?
        ohai "mycode: Detecting local code signing certificate, automatically signing the upgraded binary..."
        begin
          system "#{bin}/mycode-setup-codesign", "--silent"
        rescue => e
          opoo "mycode: automatic codesign failed (this is expected during sandbox installations): #{e.message}"
          opoo "Please run 'mycode-setup-codesign' manually after installation."
        end
      end
    end
  end

  def caveats
    <<~EOS
      For macOS Keychain access, if you want zero-prompt silent operation,
      please run the setup script:
        mycode-setup-codesign

      If you want to completely uninstall mycode and clear all Keychain credentials,
      please run the following command BEFORE running 'brew uninstall':
        mycode-setup-codesign --clean
    EOS
  end

  test do
    assert_match "mycode", shell_output("#{bin}/mycode --help")
  end
end

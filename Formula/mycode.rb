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
  version "0.1.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/aaa2015/mycode/releases/download/v#{version}/mycode-v#{version}-aarch64-apple-darwin.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "07fcdcb3345bbfc77aebd7c75149f6e80d35f090dfd76a95727cebec5a32da6d"
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

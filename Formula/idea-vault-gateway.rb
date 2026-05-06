class IdeaVaultGateway < Formula
  desc "Local MCP gateway to Gemini (grounded search) and Perplexity Sonar"
  homepage "https://github.com/turek/idea-vault-gateway"
  url "https://github.com/turek/idea-vault-gateway/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9dcdb8ff2dbdbfad7073805e0ce892a5f832cfa193e2c62cf6f732ad739dd61d"
  license "MIT"
  head "https://github.com/turek/idea-vault-gateway.git", branch: "main"

  depends_on "uv" => :build

  def install
    ENV["UV_PYTHON_PREFERENCE"] = "only-managed"
    ENV["UV_PYTHON"] = "3.12"
    ENV["UV_PYTHON_INSTALL_DIR"] = libexec/"python"
    ENV["UV_TOOL_DIR"] = libexec/"tools"
    ENV["UV_TOOL_BIN_DIR"] = libexec/"bin"

    system "uv", "tool", "install", "idea-vault-gateway==#{version}", "--no-cache"

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  def caveats
    <<~EOS
      Idea Vault Gateway is installed. Two commands to finish setup:

        1. idea-vault-gateway init
           (prompts for GEMINI_API_KEY and PERPLEXITY_API_KEY, stores them
            at ~/.config/idea-vault-gateway/.env with mode 0600)

        2. claude mcp add idea-vault-gateway idea-vault-gateway mcp --scope user
           (registers the server with Claude Code)

      Restart Claude Code and run `/mcp` to verify.
    EOS
  end

  test do
    system bin/"idea-vault-gateway", "version"
  end
end

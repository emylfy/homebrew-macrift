# Source-of-truth template for the macrift Homebrew formula.
# scripts/release.sh renders this into the tap (emylfy/homebrew-macrift) on
# release: https://github.com/emylfy/macrift/releases/download/v26.06.1/macrift-26.06.1.tar.gz and 245b054272202929e981059cf38abfb0659e4760653727cd0f7633e46e084b70 are substituted with the published asset URL and
# its sha256. Do not hand-edit Formula/macrift.rb in the tap — edit this instead.
class Macrift < Formula
  desc "Interactive macOS setup TUI with previewed, reversible changes"
  homepage "https://github.com/emylfy/macrift"
  url "https://github.com/emylfy/macrift/releases/download/v26.06.1/macrift-26.06.1.tar.gz"
  sha256 "245b054272202929e981059cf38abfb0659e4760653727cd0f7633e46e084b70"
  license "MIT"

  # bash 4+ is a hard requirement (macrift.sh exits on 3.2); python3 backs the
  # manifest/journal engine.
  depends_on "bash"
  depends_on :macos
  depends_on "python@3.13"

  def install
    # The whole tree must stay together — macrift.sh sources its siblings
    # relative to its own path (get_script_dir).
    libexec.install Dir["*"]
    # Wrapper puts Homebrew's bash 4+ first on PATH so `#!/usr/bin/env bash`
    # resolves to it, and keeps BASH_SOURCE pointing inside libexec.
    (bin/"macrift").write_env_script libexec/"macrift.sh",
                                     PATH: "#{Formula["bash"].opt_bin}:$PATH"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/macrift --help")
  end
end

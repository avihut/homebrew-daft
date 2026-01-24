class Daft < Formula
  desc "A comprehensive Git extensions toolkit that enhances developer workflows, starting with powerful worktree management"
  homepage "https://github.com/avihut/daft"
  version "0.1.27"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v0.1.27/daft-aarch64-apple-darwin.tar.xz"
      sha256 "5022b1341a3d3816c6a58931e96370549697a7823e8957f832eb5a6aca0274cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v0.1.27/daft-x86_64-apple-darwin.tar.xz"
      sha256 "bc17cbd08b3589f5e8780cc43b0e6a53b835eed6a37a739332c84074ff3e8eb2"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":  {},
    "x86_64-apple-darwin":   {},
    "x86_64-pc-windows-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "daft" if OS.mac? && Hardware::CPU.arm?
    bin.install "daft" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  def caveats
    <<~EOS
      To enable automatic cd into new worktrees, add to your shell config:
        daft setup

      To install command shortcuts (gwtco, gwtcb, etc.):
        daft setup shortcuts enable git

      For more information:
        daft --help
    EOS
  end
end

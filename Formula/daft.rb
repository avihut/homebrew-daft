class Daft < Formula
  desc "A comprehensive Git extensions toolkit that enhances developer workflows, starting with powerful worktree management"
  homepage "https://github.com/avihut/daft"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v0.3.0/daft-aarch64-apple-darwin.tar.xz"
      sha256 "683ff3de178e1623744b4b5e17aa29a4090a6155a967d054955ff417729025f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v0.3.0/daft-x86_64-apple-darwin.tar.xz"
      sha256 "5add1363a8260f7f1b45d96617c4110f8b85b6d603e3df3e492d3754d57250c5"
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
end

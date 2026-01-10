class Daft < Formula
  desc "A comprehensive Git extensions toolkit that enhances developer workflows, starting with powerful worktree management"
  homepage "https://github.com/avihut/daft"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v0.2.1/daft-aarch64-apple-darwin.tar.xz"
      sha256 "28d59bb2759861d3cc47d800f3e64af45e4af1fd0197e2e5d9414a260ca56638"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v0.2.1/daft-x86_64-apple-darwin.tar.xz"
      sha256 "a45d666f3b92d06e933643b5497b78a96cbf83e8f8e80b724c399f46fb1ce903"
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

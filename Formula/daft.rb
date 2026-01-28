class Daft < Formula
  desc "A comprehensive Git extensions toolkit that enhances developer workflows, starting with powerful worktree management"
  homepage "https://github.com/avihut/daft"
  version "1.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.0.13/daft-aarch64-apple-darwin.tar.xz"
      sha256 "bc3361f3623dddb797c01688edfcec064ed6d0aa4a11a6b313f02289131ba1ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.0.13/daft-x86_64-apple-darwin.tar.xz"
      sha256 "cf53c0317e5b5fa7c3270e1de0161b260a127dea2c822766cfe24647117e6a94"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":  {
      daft: %w[
        git-worktree-clone
        git-worktree-init
        git-worktree-checkout
        git-worktree-checkout-branch
        git-worktree-checkout-branch-from-default
        git-worktree-prune
        git-worktree-carry
        git-worktree-fetch
        git-worktree-flow-adopt
        git-worktree-flow-eject
        git-daft
      ],
    },
    "x86_64-apple-darwin":   {
      daft: %w[
        git-worktree-clone
        git-worktree-init
        git-worktree-checkout
        git-worktree-checkout-branch
        git-worktree-checkout-branch-from-default
        git-worktree-prune
        git-worktree-carry
        git-worktree-fetch
        git-worktree-flow-adopt
        git-worktree-flow-eject
        git-daft
      ],
    },
    "x86_64-pc-windows-gnu": {
      "daft.exe": [
        "git-worktree-clone.exe",
        "git-worktree-init.exe",
        "git-worktree-checkout.exe",
        "git-worktree-checkout-branch.exe",
        "git-worktree-checkout-branch-from-default.exe",
        "git-worktree-prune.exe",
        "git-worktree-carry.exe",
        "git-worktree-fetch.exe",
        "git-worktree-flow-adopt.exe",
        "git-worktree-flow-eject.exe",
        "git-daft.exe",
      ],
    },
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

    # Install pre-generated man pages
    man1.install Dir[buildpath/"man/*.1"]
  end

  def caveats
    <<~EOS
      To complete setup (shell integration + shortcuts), run:
        daft setup

      This enables automatic cd into new worktrees and installs
      git-style shortcuts (gwtco, gwtcb, gwtcbm, etc.)

      For more information:
        daft --help
    EOS
  end
end

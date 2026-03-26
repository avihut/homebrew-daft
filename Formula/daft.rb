class Daft < Formula
  desc "A comprehensive Git extensions toolkit that enhances developer workflows, starting with powerful worktree management"
  homepage "https://github.com/avihut/daft"
  version "1.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.5.1/daft-aarch64-apple-darwin.tar.xz"
      sha256 "c5cb16bdb498b7545b3c77e6d824742c77ccbb67420b963fd8ce190edf72f376"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.5.1/daft-x86_64-apple-darwin.tar.xz"
      sha256 "bb8176c2378887542b35f3641c81b00183b835fca6a415b8c7ee944a805aed5c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.5.1/daft-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b7052e61978a1751b6c38d4429c0d8ec277ee02edd4109854c978871806113b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.5.1/daft-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "983a0be87a0229fd73486ad163ac0bc19c53c0b2ca47e6b9765765dfdc5d2c09"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {
      daft: %w[
        git-worktree-clone
        git-worktree-init
        git-worktree-checkout
        git-worktree-branch
        git-worktree-branch-delete
        git-worktree-prune
        git-worktree-carry
        git-worktree-fetch
        git-worktree-flow-adopt
        git-worktree-flow-eject
        git-worktree-list
        git-worktree-sync
        git-daft
        daft-remove
        daft-rename
      ],
    },
    "aarch64-unknown-linux-gnu": {
      daft: %w[
        git-worktree-clone
        git-worktree-init
        git-worktree-checkout
        git-worktree-branch
        git-worktree-branch-delete
        git-worktree-prune
        git-worktree-carry
        git-worktree-fetch
        git-worktree-flow-adopt
        git-worktree-flow-eject
        git-worktree-list
        git-worktree-sync
        git-daft
        daft-remove
        daft-rename
      ],
    },
    "x86_64-apple-darwin":       {
      daft: %w[
        git-worktree-clone
        git-worktree-init
        git-worktree-checkout
        git-worktree-branch
        git-worktree-branch-delete
        git-worktree-prune
        git-worktree-carry
        git-worktree-fetch
        git-worktree-flow-adopt
        git-worktree-flow-eject
        git-worktree-list
        git-worktree-sync
        git-daft
        daft-remove
        daft-rename
      ],
    },
    "x86_64-pc-windows-gnu":     {
      "daft.exe": [
        "git-worktree-clone.exe",
        "git-worktree-init.exe",
        "git-worktree-checkout.exe",
        "git-worktree-branch.exe",
        "git-worktree-branch-delete.exe",
        "git-worktree-prune.exe",
        "git-worktree-carry.exe",
        "git-worktree-fetch.exe",
        "git-worktree-flow-adopt.exe",
        "git-worktree-flow-eject.exe",
        "git-worktree-list.exe",
        "git-worktree-sync.exe",
        "git-daft.exe",
        "daft-remove.exe",
        "daft-rename.exe",
      ],
    },
    "x86_64-unknown-linux-gnu":  {
      daft: %w[
        git-worktree-clone
        git-worktree-init
        git-worktree-checkout
        git-worktree-branch
        git-worktree-branch-delete
        git-worktree-prune
        git-worktree-carry
        git-worktree-fetch
        git-worktree-flow-adopt
        git-worktree-flow-eject
        git-worktree-list
        git-worktree-sync
        git-daft
        daft-remove
        daft-rename
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
    bin.install "daft" if OS.linux? && Hardware::CPU.arm?
    bin.install "daft" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files - ["man"]

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.

    # Install pre-generated man pages
    man1.install Dir[buildpath/"man/*.1"]

    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  def caveats
    <<~EOS
      To complete setup (shell integration + shortcuts), run:
        daft setup

      This enables automatic cd into new worktrees and installs
      git-style shortcuts (gwtco, gwtcb, etc.)

      For more information:
        daft --help
    EOS
  end
end

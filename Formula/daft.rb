class Daft < Formula
  desc "A comprehensive Git extensions toolkit that enhances developer workflows, starting with powerful worktree management"
  homepage "https://github.com/avihut/daft"
  version "1.6.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.6.4/daft-aarch64-apple-darwin.tar.xz"
      sha256 "0a3d940f7f65c5be1926ff62ee506658b3d0da4a11fe99af8a43e35c5abdbe42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.6.4/daft-x86_64-apple-darwin.tar.xz"
      sha256 "d64a736b305174a589c3e25c813e8930034c8dc754239ba4d39555483d87d5d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.6.4/daft-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0ed9d5c03962e3902a4fc31f9ee15bce8b7f6ef601c52cf68c3b51397253569f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.6.4/daft-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d671dcd080e2541eb0c50fd27827db99142636394caf539400ca05944d26dc45"
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
        daft-go
        daft-start
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
        daft-go
        daft-start
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
        daft-go
        daft-start
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
        "daft-go.exe",
        "daft-start.exe",
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
        daft-go
        daft-start
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

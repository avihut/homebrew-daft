class Daft < Formula
  desc "A comprehensive Git extensions toolkit that enhances developer workflows, starting with powerful worktree management"
  homepage "https://github.com/avihut/daft"
  version "1.28.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.28.2/daft-aarch64-apple-darwin.tar.xz"
      sha256 "f79c2c3c81ebcf37a8ce9402f6692ddb290ddfe828ce6e07bbedd875fe3238e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.28.2/daft-x86_64-apple-darwin.tar.xz"
      sha256 "e2360597e2469cb982ba51fa2aeb5f5033d03fde87aeb73cf700f0d90c292501"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.28.2/daft-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b6872b92122d6831f536304d38f5ea8ef4fae7c678928bc477abf9b97f5a726"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.28.2/daft-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c09e0fd6f44638e7d73c9d27c5496719fce0a0c6556fe60a3f40fe20fc04aef"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
        git-worktree-list
        git-worktree-merge
        git-worktree-exec
        git-worktree-sync
        git-worktree-push
        git-worktree-warm
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
        git-worktree-list
        git-worktree-merge
        git-worktree-exec
        git-worktree-sync
        git-worktree-push
        git-worktree-warm
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
        git-worktree-list
        git-worktree-merge
        git-worktree-exec
        git-worktree-sync
        git-worktree-push
        git-worktree-warm
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
        "git-worktree-list.exe",
        "git-worktree-merge.exe",
        "git-worktree-exec.exe",
        "git-worktree-sync.exe",
        "git-worktree-push.exe",
        "git-worktree-warm.exe",
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
        git-worktree-list
        git-worktree-merge
        git-worktree-exec
        git-worktree-sync
        git-worktree-push
        git-worktree-warm
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "daft"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "daft"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "daft"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "daft"
    end

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
      To activate daft (shell integration + shortcuts), run:
        daft activate

      This enables automatic cd into new worktrees and installs
      git-style shortcuts (gwtco, gwtcb, etc.)

      For more information:
        daft --help
    EOS
  end
end

class Daft < Formula
  desc "A comprehensive Git extensions toolkit that enhances developer workflows, starting with powerful worktree management"
  homepage "https://github.com/avihut/daft"
  version "1.28.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.28.1/daft-aarch64-apple-darwin.tar.xz"
      sha256 "ded142be9503ec4a2c5220c8dc9442ed924899bfb4c7cf6fb39dad5df9fbc0b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.28.1/daft-x86_64-apple-darwin.tar.xz"
      sha256 "019f968bc1ecf06d64a8e07b5630db6a2eaa2a7c0e0addfb1cb2994c862f7855"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.28.1/daft-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "00605c1adcc0c64665305e878b19c1bde58cfc51fc4a072425c12c99799b5bff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.28.1/daft-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8f8133fe2d4aa0bf9a9185028592f1e319df7248195572639f5c78458aac135f"
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

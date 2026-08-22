class Daft < Formula
  desc "A comprehensive Git extensions toolkit that enhances developer workflows, starting with powerful worktree management"
  homepage "https://github.com/avihut/daft"
  version "1.27.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.27.5/daft-aarch64-apple-darwin.tar.xz"
      sha256 "2415b985fa1b08fc4d681f9938cf21dfb284fffcf97610a645d48932c04e7ab5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.27.5/daft-x86_64-apple-darwin.tar.xz"
      sha256 "537533bcd4521de9e2a395d5568708adfd1bb52d9b63a09751e64d55bc39dab0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.27.5/daft-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe7f2e13125b9ac7679abd14ec755421639fa2589cb28a3637a6fdfc29750e2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.27.5/daft-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7a83f7c0e18194fce88b6e7eece4ae4ed202c9ddfcc868839e8d4cf107b9b7f7"
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

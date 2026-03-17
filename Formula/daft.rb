class Daft < Formula
  desc "A comprehensive Git extensions toolkit that enhances developer workflows, starting with powerful worktree management"
  homepage "https://github.com/avihut/daft"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.2.1/daft-aarch64-apple-darwin.tar.xz"
      sha256 "ebc327af6353688a5a4a07747e058fca62fb9175210e1171df61b3f22f0e86e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.2.1/daft-x86_64-apple-darwin.tar.xz"
      sha256 "4d9baabf4ffaaa9a7f7e44eaccbe0139fc8d2de5ba9062c36eb1be8fe5646093"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/avihut/daft/releases/download/v1.2.1/daft-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f28bd628391523331d753d467662a745618fbc0a4f066f226807e11f76e01fa4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/avihut/daft/releases/download/v1.2.1/daft-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7caae290c78d48427d1bffb3e079215f8e0d240eeda50a3b0146e3648ab8107e"
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

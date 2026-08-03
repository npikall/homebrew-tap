class Gotpm < Formula
  desc "A minimal package manager for Typst"
  homepage "https://github.com/npikall/gotpm"
  url "https://github.com/npikall/gotpm/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "101675d13ebdf59749f3252faa168d1f40a2d71e8fc4f94fe9bb5bb9b1f0c16a"
  license "MIT"

  depends_on "go" => :build

  def install
    cpu_arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/npikall/gotpm/cmd.gitTag=#{version}
      -X github.com/npikall/gotpm/cmd.buildOS=#{OS.kernel_name.downcase}
      -X github.com/npikall/gotpm/cmd.buildARCH=#{cpu_arch}
      -X github.com/npikall/gotpm/cmd.installer=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-mod=vendor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotpm --version")
  end
end

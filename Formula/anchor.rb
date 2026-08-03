class Anchor < Formula
  desc "Pin GitHub Action Jobs"
  homepage "https://github.com/npikall/anchor"
  # No releases yet — pinned to a development commit. Run the update workflow after first release.
  url "https://github.com/npikall/anchor/archive/102e7eaddb23d6a122f8a587756a7db4a9a9dae0.tar.gz"
  sha256 "31edd03e93b9f8712b0bc076678c6d16426e88777f3f8cf2f34fe7780837d560"
  version "0.0.0-dev"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_predicate bin/"anchor", :exist?
  end
end

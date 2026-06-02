class GoTypstwatch < Formula
  desc "A server to watch Typst PDF files with live refresh"
  homepage "https://github.com/npikall/go-typstwatch"
  # No releases yet — pinned to a development commit. Run the update workflow after first release.
  url "https://github.com/npikall/go-typstwatch/archive/refs/tags/{"message":"Not Found","documentation_url":"https://docs.github.com/rest/releases/releases#get-the-latest-release","status":"404"}.tar.gz"
  sha256 "d8bcebb66d589a971e91c1c6a839bb1d5186f0c8d922925775370bbfa83d212a"
  version "0.0.0-dev"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_predicate bin/"go-typstwatch", :exist?
  end
end

class Bibcheck < Formula
  desc "A small cli to check the validity of bib files"
  homepage "https://github.com/npikall/bibcheck"
  # No releases yet — pinned to a development commit. Run the update workflow after first release.
  url "https://github.com/npikall/bibcheck/archive/942d15078e087256b7ce8b08595eaf2085cf2fe3.tar.gz"
  sha256 "459eca6fd249b08962f60e932f8397cb00cf6cffd1dfdb4c858c2a70be661ce7"
  version "0.0.0-dev"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_predicate bin/"bibcheck", :exist?
  end
end

class MynewtNewt < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_3_0_tag.tar.gz"
  version "1.3.0"
  sha256 "6fa33e4dae06ff8b6c8788a24b6c29f0587d82dcdc5fe58ea16dcd5078d34076"

  head "https://github.com/apache/mynewt-newt.git"

  bottle do
    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.3.0"
    cellar :any_skip_relocation
    sha256 "7f98f1b86092e5fc81660ad7ab90591c47f8b01aa8cd6b4aff4959809c3ea91d" => :sierra
  end

  depends_on "go" => :build
  depends_on :arch => :x86_64

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/mynewt.apache.org/newt").install contents
    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    cd gopath/"src/mynewt.apache.org/newt/newt" do
      system "go", "install"
      bin.install gopath/"bin/newt"
    end
  end

  test do
    # Compare newt version string
    assert_equal "1.3.0", shell_output("#{bin}/newt version").split.last
  end
end

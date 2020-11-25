class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.2.0.tar.gz"
  sha256 "75d80dcd3258569e187d189f96f79de544332b72d635cc20b5111453d03c3a2d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c36ed9de017a0f0c0f5a70f7c33fd5387b6f3ccdee14399f1c7b445a3ca9d3fa" => :big_sur
    sha256 "64bcae8e6372b6db077687eabdfb358e7393403fc7229d430941e352d6151df9" => :catalina
    sha256 "a5e7dddbdde2fa4dd35db661559eef21cfc8eaf98234912605cd91cbfb1f3671" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}", "-trimpath", "-o", bin/name
  end

  test do
    (testpath/"test.md").write <<~EOS
      # header

      **bold**

      ```
      code
      ```
    EOS
    assert_match "# header", shell_output("#{bin}/glow test.md")
  end
end

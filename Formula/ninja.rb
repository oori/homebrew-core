class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.1.tar.gz"
  sha256 "a6b6f7ac360d4aabd54e299cc1d8fa7b234cd81b9401693da21221c62569a23e"
  license "Apache-2.0"
  revision 3
  head "https://github.com/ninja-build/ninja.git"

  livecheck do
    url "https://github.com/ninja-build/ninja/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 "c5b5be39f81d648fd690f26fbccdb3fafba6d2ccb2454233c2e9cce5e74d6764" => :big_sur
    sha256 "c608321fd864f4ab3fe7b5778743ac48e6e0676d7ccb336825e4a7da1eb49cc6" => :catalina
    sha256 "6e11b8043a806c7845de5f0d21410a5a5fb253829b23df33235900b1006ac9d7" => :mojave
  end

  depends_on "python@3.9"

  # from https://github.com/ninja-build/ninja/pull/1836, remove in next release
  patch do
    url "https://github.com/ninja-build/ninja/commit/2f3e5275e2ea67cb634488957adbb997c2ff685f.patch?full_index=1"
    sha256 "77e96405d6f2d4dbeee07b07186b5963257573fd470894a1ed78e5e6a288e5eb"
  end

  def install
    py = Formula["python@3.9"].opt_bin/"python3"
    system py, "./configure.py", "--bootstrap", "--verbose", "--with-python=#{py}"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    EOS
    system bin/"ninja", "-t", "targets"
    port = free_port
    fork do
      exec bin/"ninja", "-t", "browse", "--port=#{port}", "--no-browser", "foo.o"
    end
    sleep 2
    assert_match "foo.c", shell_output("curl -s http://localhost:#{port}?foo.o")
  end
end

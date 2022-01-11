class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.9/apache-tomee-8.0.9-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.9/apache-tomee-8.0.9-webprofile.tar.gz"
  sha256 "5f64747ddd17187a8064807e6bd548773041921b0769e708357bb79f07f18a28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a102467d05169d07fc6e28d747eb4d25f0b30978574014b88f9bba56e838511b"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    (bin/"tomee-webprofile-startup").write_env_script "#{libexec}/bin/startup.sh",
                                                      Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Apache TomEE Web is:
        #{opt_libexec}
      To run Apache TomEE:
        #{opt_libexec}/bin/tomee-webprofile-startup
    EOS
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "#{opt_libexec}/bin/configtest.sh"
  end
end

name "ruby"

license "BSD-2-Clause"
license_file "BSDL"
license_file "COPYING"
license_file "LEGAL"
skip_transitive_dependency_licensing true

default_version "2.6.5"

dependency "zlib"
dependency "openssl"
dependency "libffi"
dependency "libyaml"

version("2.6.5")      { source sha256: "66976b716ecc1fd34f9b7c3c2b07bbd37631815377a2e3e85a5b194cfdcbed7d" }

source url: "https://cache.ruby-lang.org/pub/ruby/#{version.match(/^(\d+\.\d+)/)[0]}/ruby-#{version}.tar.gz"

relative_path "ruby-#{version}"

env = with_standard_compiler_flags(with_embedded_path)
env["CFLAGS"] << " -O3 -g -pipe"

build do
  configure_command = ["--with-out-ext=dbm,readline",
                       "--enable-shared",
                       "--disable-install-doc",
                       "--without-gmp",
                       "--without-gdbm",
                       "--without-tk",
                       "--disable-dtrace",
                       "--with-bundled-md5",
                       "--disable-jit-support",
                       "--with-opt-dir=#{install_dir}/embedded"]
  configure(*configure_command, env: env)
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end

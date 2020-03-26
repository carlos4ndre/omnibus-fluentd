name "zlib"
default_version "1.2.11"

version("1.2.11") { source sha256: "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1" }

source url: "https://zlib.net/fossils/zlib-#{version}.tar.gz"

license "Zlib"
license_file "README"
skip_transitive_dependency_licensing true

relative_path "zlib-#{version}"

build do
  env = with_standard_compiler_flags

  configure env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end

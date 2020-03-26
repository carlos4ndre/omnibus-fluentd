name "libyaml"
default_version "0.1.7"

license "MIT"
license_file "LICENSE"
skip_transitive_dependency_licensing true

dependency "config_guess"

version("0.1.7") { source sha256: "8088e457264a98ba451a90b8661fcb4f9d6f478f7265d48322a196cec2480729" }

source url: "https://pyyaml.org/download/libyaml/yaml-#{version}.tar.gz"

relative_path "yaml-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)
  update_config_guess(target: "config")
  configure "--enable-shared", env: env
  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end

name "config_guess"
default_version "master"

source git: "https://github.com/chef/config-mirror.git"

license "GPL-3.0 (with exception)"
license_file "config.guess"
license_file "config.sub"
skip_transitive_dependency_licensing true

relative_path "config_guess-#{version}"

build do
  mkdir "#{install_dir}/embedded/lib/config_guess"

  copy "#{project_dir}/config.guess", "#{install_dir}/embedded/lib/config_guess/config.guess"
  copy "#{project_dir}/config.sub", "#{install_dir}/embedded/lib/config_guess/config.sub"
end

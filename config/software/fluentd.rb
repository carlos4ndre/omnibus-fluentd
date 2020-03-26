name "fluentd"

# v1.9.3
default_version "9f856f621f7c71449fa5031b30367d41e7419188"
skip_transitive_dependency_licensing true

dependency "ruby"
dependency "jemalloc"

source :git => "https://github.com/fluent/fluentd.git"

relative_path "fluentd"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Install required core gems
  Dir.glob(File.expand_path(File.join(Omnibus::Config.project_root, "core_gems", "*.gem"))).sort.each { |gem_path|
    gem "install --no-document #{gem_path}", env: env
  }

  # Install required fluentd plugins
  Dir.glob(File.expand_path(File.join(Omnibus::Config.project_root, "plugin_gems", "*.gem"))).sort.each { |gem_path|
    gem "install --no-ri --no-rdoc #{gem_path}", :env => env
  }

  rake "build", env: env
  gem "install --no-document pkg/fluentd-*.gem", env: env
end

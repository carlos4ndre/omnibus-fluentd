name "fluentd"
maintainer "John Doe"
homepage "https://youwebsite.com"
description "Fluentd agent"

# Defaults to /opt/fluentd
install_dir "#{default_root}/#{name}"

build_version "1.9.3"
build_iteration 0

# Creates required build directories
dependency "preparation"
override :ruby, :version => '2.6.5'

# fluentd dependencies/components
dependency "fluentd"
dependency "fluentd_files"

exclude "**/.git"
exclude "**/bundler/git"

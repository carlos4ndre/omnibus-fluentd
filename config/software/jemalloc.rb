name "jemalloc"

default_version "5.1.0"

version("5.1.0") { source :sha256 => '5396e61cc6103ac393136c309fae09e44d74743c86f90e266948c50f3dbb7268' }

source :url => "https://github.com/jemalloc/jemalloc/releases/download/#{version}/jemalloc-#{version}.tar.bz2"
relative_path "jemalloc-#{version}"

env = with_standard_compiler_flags(with_embedded_path)

build do
  command ["./configure", '--disable-debug',
           "--prefix=#{install_dir}/embedded"].join(" "), :env => env
  make "-j #{workers}", :env => env
  make "install", :env => env
end

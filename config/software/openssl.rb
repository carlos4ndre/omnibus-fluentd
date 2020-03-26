name "openssl"

license "OpenSSL"
license_file "LICENSE"
skip_transitive_dependency_licensing true

dependency "cacerts"

default_version "1.1.1d"

source url: "https://www.openssl.org/source/openssl-#{version}.tar.gz", extract: :lax_tar

version("1.1.1d") { source sha256: "1e3a91bc1f9dfce01af26026f856e064eab4c8ee0a8f457b5ae30b40b8b711f2" }

relative_path "openssl-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  patch_env = env
  patch source: "openssl-1.1.0f-do-not-install-docs.patch", env: patch_env

  configure_args = [
    "--prefix=#{install_dir}/embedded",
    "no-comp",
    "no-idea",
    "no-mdc2",
    "no-rc5",
    "no-ssl2",
    "no-ssl3",
    "no-zlib",
    "shared",
  ]
  configure_cmd = "./config disable-gost"
  configure_args << env["CFLAGS"] << env["LDFLAGS"]
  configure_command = configure_args.unshift(configure_cmd).join(" ")
  command configure_command, env: env, in_msys_bash: true

  make "depend", env: env
  make env: env
  make "install", env: env
end

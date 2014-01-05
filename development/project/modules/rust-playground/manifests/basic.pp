define rust-playground::basic {

  $rust_version = '0.9'
  $rust_name = "rust-${rust_version}"
  $rust_package = "${rust_name}.tar.gz"
  $rust_package_md5 = '6446642f5094800d4380c7aabca82de4'

  package { "g++":
    ensure => "installed"
  }

  exec {
    'rust-package-download':
      command     => "/usr/bin/wget -O ${rust_package} http://static.rust-lang.org/dist/${rust_package}",
      cwd         => '/opt',
      notify      => Exec['rust-src-retrieval'],
      onlyif      => "/bin/bash -c '[ ! -f /opt/${rust_package} ] || ! md5sum /opt/${rust_package} | grep ${rust_package_md5} > /dev/null '",
      timeout     => 0,
      ;
    'rust-src-retrieval':
      command     => "/bin/tar -xzf ${rust_package}",
      refreshonly => true,
      cwd         => "/opt",
      notify      => Exec['rust-configure'],
      require     => Exec['rust-package-download'],
      ;
    'rust-configure':
      command     => "/bin/bash -c './configure'",
      cwd         => "/opt/${rust_name}",
      # refreshonly => true,
      notify      => Exec['rust-make'],
      require     => Exec['rust-src-retrieval'],
      timeout     => 0,
      ;
    'rust-make':
      command     => "/usr/bin/make",
      cwd         => "/opt/${rust_name}",
      # refreshonly => true,
      notify      => Exec['rust-make-install'],
      require     => Exec['rust-configure'],
      timeout     => 0,
      ;
    'rust-make-install':
      command     => "/usr/bin/make install",
      cwd         => "/opt/${rust_name}",
      # refreshonly => true,
      require     => Exec['rust-make'],
      timeout     => 0,
      ;
  }

}

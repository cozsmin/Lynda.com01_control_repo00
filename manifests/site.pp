node default {
  file { '/tmp/node_default':
    ensure => file,
    content => "Los ACUCARACIAS\n",
    owner   => 'bin',
  }
}

node 'puppet' {

  $url = 'https://piston-data.mojang.com/v1/objects/561c7b2d54bae80cc06b05d950633a9ac95da816/server.jar'

  include role::master_server

  file { '/tmp/node_puppet':
    ensure => file,
    content => 'Los ACUCARACIAS 333\n',
  }

  file { "/opt/nfs":
    ensure => directory,
  }

  package { 'wget':
    ensure => present,
  }

  package { 'nfs-utils':
    ensure => present,
  }

  file {'/etc/exports':
    ensure => file,
    mode => "644",
    owner => 'root',
    group => 'root',
    notify  => Service['nfs-server']
  }

  file_line {'etc_exports':
    path => '/etc/exports',
    line => '/opt/nfs 192.168.56.0/24(ro)',
  }

  service {'nfs-server':
    ensure => running,
    enable => true,
  }

  exec { 'wget server.jar as minecraft_server.jar':
    command  => [ "/bin/bash" , "-c" , "if [ -f minecraft_server.jar ] ; then exit 0 ; fi; wget ${url} && mv -f server.jar minecraft_server.jar" ],
#    command  => [ "/bin/bash" , "-c" , "wget ${url} && mv -f server.jar minecraft_server.jar" ],
    cwd      => '/opt/nfs',
  }
}

node /^web|^d12b-ps/ {
  include role::app_server
}

node /^db|^d12c-ps/ {
  include role::db_server
  include role::minecraft
}


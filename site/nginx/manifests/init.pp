class nginx (
  $package  = $nginx::params::package,
  $owner    = $nginx::params::owner,
  $group    = $nginx::params::group,
  $docroot  = $nginx::params::docroot,
  $confdir  = $nginx::params::confdir,
  $blockdir = $nginx::params::blockdir,
  $logdir   = $nginx::params::logdir,
  $service  = $nginx::params::service,
  $user     = $nginx::params::user,
  $message  = 'This is the default value',
) inherits nginx::params {
  
  File {
    owner => $owner,
    group => $group,
    mode  => '0664',
  }

  package { $package:
    ensure => present,
  }
  
  file { $docroot:
    ensure  => directory,
    mode    => '0755',
    before  => File["${docroot}/index.html"],
    require => Package[$package],
  }
  
  file { "${docroot}/index.html":
    ensure => file,
    #source => 'puppet:///modules/nginx/index.html',
    content => epp('nginx/index.html.epp', { message => $message, }),
  }
  
  file { "${confdir}/nginx.conf":
    ensure  => file,
    #source  => 'puppet:///modules/nginx/nginx.conf',
    content => epp('nginx/nginx.conf.epp',
                    {
                      user     => $user,
                      logdir   => $logdir,
                      confdir  => $confdir,
                      blockdir => $blockdir,
                    }),
    require => Package[$package],
  }
  
  file { $blockdir:
    ensure  => directory,
    mode    => '0755',
    require => Package[$package],
  }
  
  file { "${blockdir}/default.conf":
    ensure  => file,
    #source  => 'puppet:///modules/nginx/default.conf',
    content => epp('nginx/default.conf.epp', { docroot => $docroot, }),
    require => File[$blockdir],
  }
  
  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [File["${confdir}/nginx.conf"], File["${blockdir}/default.conf"]],
  }
}
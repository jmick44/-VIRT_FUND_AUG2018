class nginx::params {  
  #case $::osfamily {
  case $facts['os']['family'] {
    'redhat', 'debian': {
      $package  = 'nginx'
      $owner    = 'root'
      $group    = 'root'
      $docroot  = '/var/www'
      $confdir  = '/etc/nginx'
      $blockdir = '/etc/nginx/conf.d'
      $logdir   = '/var/log/nginx'
      $service  = 'nginx'
    }
    'windows': {
      $package  = 'nginx-service'
      $owner    = 'Administrator'
      $group    = 'Administrators'
      $docroot  = 'C:/ProgramData/nginx/html'
      $confdir  = 'C:/ProgramData/nginx'
      $blockdir = 'C:/ProgramData/nginx/conf.d'
      $logdir   = 'C:/ProgramData/nginx/logs'
      $service  = 'nginx'
    }
    default: {
      fail("OS Family ${::osfamily} is not supported")
    }
  }
  
  $user = $facts['os']['family'] ? {
    'redhat'  => 'nginx',
    'debian'  => 'www-data',
    'windows' => 'nobody',
    default   => 'fail',
  }
  
  if $user == 'fail' {
    fail("OS Family ${::osfamily} is not supported")
  }
}
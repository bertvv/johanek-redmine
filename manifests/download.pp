# Class redmine::download
class redmine::download {

  Exec {
    cwd  => '/usr/src',
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
  }

  exec { 'redmine_source':
    command => "wget ${::redmine::params::download_url}",
    creates => "${::redmine::src}.tar.gz",
  } ->

  exec { 'extract_redmine':
    command => "/bin/tar xvzf ${::redmine::src}.tar.gz",
    creates => $::redmine::src
  } ->

  file { "${::redmine::src}/config/database.yml":
    ensure  => present,
    content => template('redmine/database.yml.erb'),
  } ->

  file { "${::redmine::src}/config/configuration.yml":
    ensure  => present,
    content => template('redmine/configuration.yml.erb'),
  }


}

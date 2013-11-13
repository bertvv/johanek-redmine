# Class redmine::config
class redmine::config {

  require 'apache'

  File {
    owner => $::redmine::params::apache_user,
    group => $::redmine::params::apache_group,
    mode  => '0644'
  }

  file { '/var/www/html/redmine':
    ensure => link,
    target => $::redmine::src
  }

  Exec {
    cmd => "/bin/chown -R ${::redmine::params::apache_user}.${::redmine::params::apache_group} ${::redmine::src}"
  }

  apache::vhost { 'redmine':
    port          => '80',
    docroot       => '/var/www/html/redmine/public',
    servername    => $::fqdn,
    serveraliases => 'redmine',
    options       => 'Indexes FollowSymlinks ExecCGI'
  }

  # Log rotation
  file { '/etc/logrotate.d/redmine':
    ensure => present,
    source => 'puppet:///modules/redmine/redmine-logrotate',
    owner  => 'root',
    group  => 'root'
  }

}

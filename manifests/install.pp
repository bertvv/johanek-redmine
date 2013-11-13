# Class redmine::install
class redmine::install {

  include 'rvm'

  $ruby_short_version = regsubst($::redmine::ruby_version, '-p[0-9]+$', '')
  $ruby = "ruby-${::redmine::ruby_version}"
  $ruby_home = "/usr/local/rvm/gems/${ruby}"

  $rails_gem = "${ruby}/rails"
  $bundler_gem = "${ruby}/bundler"
  $bundler = "${ruby_home}/bin/bundle"

  rvm_system_ruby { $ruby:
    ensure      => present,
    default_use => true,
  }

  rvm_gem { $bundler_gem:
    ensure       => present,
    ruby_version => $ruby,
    require      => Rvm_system_ruby[$ruby],
  }

  rvm_gem { $rails_gem:
    ensure       => present,
    ruby_version => $ruby,
    require      => Rvm_system_ruby[$ruby],
  }


  class { 'rvm::passenger::apache':
    version            => $::redmine::passenger_version,
    ruby_version       => $ruby,
    mininstances       => '3',
    maxinstancesperapp => '0',
    maxpoolsize        => '30',
    spawnmethod        => 'smart-lv2',
  }



  Exec {
    cwd  => '/usr/src',
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/',
      "${ruby_home}/bin" ],
  }


  package { [ 'ImageMagick-devel', 'ruby-devel', 'mysql-devel' ] :
    ensure => installed,
  } ->

  exec { 'bundle_redmine':
    command   => "${bundler} install --gemfile ${::redmine::src}/Gemfile --without development test && touch .bundle",
    creates   => "${::redmine::src}/.bundle",
    logoutput => true,
    require   => Rvm_gem[$bundler_gem],
  }

}

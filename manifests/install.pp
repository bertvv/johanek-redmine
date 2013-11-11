# Class redmine::install
class redmine::install {

  Exec {
    cwd  => '/usr/src',
    path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
  }

  notice("Redmine::install using ${redmine::ruby_home}/bin/bundle")

  $bundler = "${redmine::ruby_home}/bin/bundle"

  exec { 'redmine_source':
    command => "wget ${redmine::params::download_url}",
    creates => "/usr/src/redmine-${redmine::version}.tar.gz",
  } ->

  exec { 'extract_redmine':
    command => "/bin/tar xvzf redmine-${redmine::version}.tar.gz",
    creates => "/usr/src/redmine-${redmine::version}"
  } ->


  exec { 'bundle_redmine':
    command => "${bundler} install --gemfile /usr/src/redmine-${redmine::version}/Gemfile --without development test && touch .bundle",
    creates => "/usr/src/redmine-${redmine::version}/.bundle",
  }

}

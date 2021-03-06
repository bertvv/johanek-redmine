#Class redmine::rake - DB migrate/prep tasks
class redmine::rake {

  $ruby_bin = '/usr/local/rvm/bin'
  $rake = "${ruby_bin}/rake --trace"

  Exec {
    path        => ['/bin','/usr/bin', $ruby_bin ],
    environment => ['HOME=/root','RAILS_ENV=production','REDMINE_LANG=en'],
    provider    => 'shell',
    cwd         => '/var/www/html/redmine',
  }

  # Create session store
  exec { 'session_store':
    command   => "${rake} generate_secret_token && /bin/touch .session_store",
    logoutput => true,
    creates   => '/var/www/html/redmine/.session_store',
  }

  # Perform rails migrations
  exec { 'rails_migrations':
    command   => "${rake} db:migrate && /bin/touch .migrate",
    creates   => '/var/www/html/redmine/.migrate',
    logoutput => true,
    notify    => Class['apache::service'],
  }

  # Seed DB data
  exec { 'seed_db':
    command   => "${rake} redmine:load_default_data && /bin/touch .seed",
    creates   => '/var/www/html/redmine/.seed',
    notify    => Class['apache::service'],
    logoutput => true,
    require   => Exec['rails_migrations'],
  }


}

# Class redmine::database
class redmine::database {

  if $redmine::database_server == 'localhost' {

    # Database {
    #  require => Class['mysql::server']
    # }

    mysql_database { [$redmine::production_database,
                      $redmine::development_database]:
      ensure  => present,
      charset => 'utf8',
    }

    mysql_user { "${redmine::database_user}@${redmine::database_server}":
      password_hash => mysql_password($redmine::database_password),
    }

    mysql_grant { "${redmine::database_user}@${redmine::database_server}/${redmine::production_database}":
      table      => '*.*',
      user       => "${redmine::database_user}@${redmine::database_server}",
      options    => ['GRANT'],
      privileges => ['ALL'],
    }

    mysql_grant { "${redmine::database_user}@${redmine::database_server}/${redmine::development_database}":
      table      => '*.*',
      user       => "${redmine::database_user}@${redmine::database_server}",
      options    => ['GRANT'],
      privileges => ['all'],
    }

  }

}

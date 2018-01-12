class mysqlServer ($root_password, $schema_name, $db_user, $db_password) {
  
  package { 'mysql-server':
    ensure => 'installed'
  }
  
  service { 'mysqld':
    ensure => 'running',
    require => Package['mysql-server']
  }

  exec { 'set-mysql-root-password':
    command => "/usr/libexec/mysql55/mysqladmin -u root password '${root_password}'",
    user => 'root',
    require => Service[ 'mysqld' ]
  }

  exec { 'create-default-schema':
    command => "/bin/echo \"create database ${schema_name};\" | /usr/bin/mysql -u root -p${root_password}",
    user => 'root',
    require => Exec[ 'set-mysql-root-password' ]
  }

  exec { 'create-default-user':
    command => "/bin/echo \"grant all on ${schema_name}.* to '${db_user}'@'%' identified by '${db_password}';\" | /usr/bin/mysql -u root -p${root_password}",
    user => 'root',
    require => Exec[ 'create-default-schema' ]
  }
  
}
import 'classes.pp'

class { 'mysqlServer':
    root_password => 'hagenberg',
    schema_name => 'app_lottery',
    db_user => 'app_lottery',
    db_password => 'app_lottery'
}
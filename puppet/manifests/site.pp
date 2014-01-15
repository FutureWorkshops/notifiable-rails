# site.pp
stage { 'req-install': before => Stage['rvm-install'] }

class requirements {
  group { "puppet": ensure => "present", }
  exec { 
    "apt-update": command => "/usr/bin/apt-get -y update"
  }

  package {
    [
      "curl", 
      "vim",
      "libmysqlclient-dev"
    ]: 
    ensure => installed, require => Exec['apt-update']
  }
}

class installrvm {
  include rvm
  rvm::system_user { vagrant: ; }
}


class installmysql {
  include mysql::server
  include mysql::client
  include mysql::bindings
  mysql::db { 'notifiable':
    user     => 'notifiable-rails',
    password => 'notifiable-rails'
  }
}
 
class installruby {
    rvm_system_ruby {
      'ruby-2.0.0-p247': ensure => 'present';
    }
}
 
class { requirements: stage => "req-install" }
class { installrvm: }
class { installruby: require => Class[Installrvm] }
class { installmysql: }
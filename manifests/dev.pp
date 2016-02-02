node default {
  # install ruby without documentation
  class { 'ruby': 
    user  => 'vagrant',   # copy .gemrc for user
  }

  # install rails
  class { 'ruby::gem':
    gem   => 'rails',
    version => '4.2.1',
    require => Class['ruby'],   # install if ruby installed
  }

  # install mysql and create a user
  class { 'ruby::dependencies::mysql::mysql':
    username  => 'vagrant',
    password  => 'vagrant',
  }
}
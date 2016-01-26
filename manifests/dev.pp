node default {
  # install ruby without documentation
  class { 'ruby': 
    user  => 'vagrant',
  }

  # install rails
  class { 'ruby::gem':
    gem   => 'rails',
    version => '4.2.1',
    require => Class['ruby'],
  }

  # install mysql and create a user
  class { 'ruby::dependencies::mysql::mysql':
    username  => 'vagrant',
    password  => 'vagrant',
  }
}
node default {
  class { 'ruby': 
    user  => 'vagrant',
  }

  # install rails
  class { 'ruby::gem':
    gem   => 'rails',
    version => '4.2.1',
    require => Class['ruby'],
  }

  class { 'ruby::dependencies::mysql::mysql':
    username  => 'vagrant',
    password  => 'vagrant',
  }
}
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

  class { 'ruby::git::clone': 
    clone_repo  => 'https://github.com/Hismahil/app-rails-jenkins-test.git', 
    toDir   => '/vagrant/app_02',
    require   => Class['ruby::gem'],
  }

  class { 'ruby::dependencies::mysql::mysql':
    username  => 'vagrant',
    password  => 'vagrant',
  }
}
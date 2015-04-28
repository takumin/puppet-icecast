# == Class icecast::config
#
# This class is called from icecast for service config.
#
class icecast::config {

  group { $::icecast::option['security']['changeowner']['group']:
    ensure  => present,
  }

  user { $::icecast::option['security']['changeowner']['user']:
    ensure  => present,
    gid     => $::icecast::option['security']['changeowner']['group'],
    comment => 'Icecast Daemon User',
    home    => '/nonexistent',
    shell   => '/usr/sbin/nologin',
    require => [
      Group[$::icecast::option['security']['changeowner']['group']],
    ],
  }

  file { $::icecast::config:
    ensure  => file,
    owner   => $::icecast::option['security']['changeowner']['user'],
    group   => $::icecast::option['security']['changeowner']['group'],
    mode    => 0400,
    content => template($::icecast::config_template),
    require => [
      User[$::icecast::option['security']['changeowner']['user']],
    ],
  }

  file {[
    $::icecast::option['paths']['logdir'],
    $::icecast::option['paths']['pidfile'],
  ]:
    ensure  => directory,
    owner   => $::icecast::option['security']['changeowner']['user'],
    group   => $::icecast::option['security']['changeowner']['group'],
    mode    => 0700,
    require => [
      User[$::icecast::option['security']['changeowner']['user']],
    ],
  }

}

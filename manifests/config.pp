# == Class icecast::config
#
# This class is called from icecast for service config.
#
class icecast::config {

  group { $::icecast::options['security']['changeowner']['group']:
    ensure  => present,
  }

  user { $::icecast::options['security']['changeowner']['user']:
    ensure  => present,
    gid     => $::icecast::options['security']['changeowner']['group'],
    comment => 'Icecast Daemon User',
    home    => '/nonexistent',
    shell   => '/sbin/nologin',
    require => [
      Group[$::icecast::options['security']['changeowner']['group']],
    ],
  }

  file { $::icecast::config:
    ensure  => file,
    owner   => $::icecast::options['security']['changeowner']['user'],
    group   => $::icecast::options['security']['changeowner']['group'],
    mode    => 0400,
    content => template($::icecast::config_template),
    require => [
      User[$::icecast::options['security']['changeowner']['user']],
    ],
  }

  file {[
    $::icecast::options['paths']['logdir'],
    $::icecast::options['paths']['pidfile'],
  ]:
    ensure  => directory,
    owner   => $::icecast::options['security']['changeowner']['user'],
    group   => $::icecast::options['security']['changeowner']['group'],
    mode    => 0700,
    require => [
      User[$::icecast::options['security']['changeowner']['user']],
    ],
  }

}

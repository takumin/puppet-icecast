# == Class icecast::params
#
# This class is meant to be called from icecast.
# It sets variables according to platform.
#
class icecast::params {
  case $::osfamily {
    'Debian', 'RedHat', 'Amazon': {
      $package_name = 'icecast'
      $service_name = 'icecast'
      $prefix       = '/usr'
    }
    'FreeBSD': {
      $package_name = 'audio/icecast2'
      $service_name = 'icecast2'
      $prefix       = '/usr/local'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  # Global Configuration
  $config           = "$prefix/etc/icecast.xml"
  $config_template  = 'icecast/icecast.xml.erb'

  $options = {
    'location'                    => 'Earth',
    'admin'                       => "icecast@$::domain",
    'limits'                      => {
      'clients'                   => 100,
      'sources'                   => 2,
      'queue-size'                => 524288,
      'client-timeout'            => 30,
      'header-timeout'            => 15,
      'source-timeout'            => 10,
      'burst-on-connect'          => 1,
      'burst-size'                => 65535,
    },
    'authentication'              => {
      'source-password'           => 'admin',
      'relay-password'            => 'admin',
      'admin-user'                => 'admin',
      'admin-password'            => 'admin',
    },
    'shoutcast-mount'             => false,
    'directory'                   => {
      'yp-url-timeout'            => false,
      'yp-url'                    => false,
    },
    'hostname'                    => $::fqdn,
    'listen-socket'               => [
      {
        'port'                    => 8000,
        'bind-address'            => $::ipaddress,
        'shoutcast-mount'         => false,
        'ssl'                     => false,
      },
    ],
    'http-headers'                => [
      {
        'name'                    => 'Access-Control-Allow-Origin',
        'value'                   => '*',
      },
    ],
    'master-server'               => false,
    'master-server-port'          => false,
    'master-update-interval'      => false,
    'master-password'             => false,
    'relays-on-demand'            => false,
    'relay'                       => {
      'server'                    => false,
      'port'                      => false,
      'mount'                     => false,
      'on-demand'                 => false,
      'relay-shoutcast-metadata'  => false,
    },
    'mount'                       => {
      'default'                   => [
        {
          'public'                => false,
          'intro'                 => false,
          'max-listener-duration' => false,
          'authentication'        => [
            {
              'name'              => false,
              'value'             => false,
            },
          ],
          'http-headers'          => [
            {
              'name'              => false,
              'value'             => false,
            },
          ],
        },
      ],
    },
    'fileserve'                   => 1,
    'paths'                       => {
      'basedir'                   => "$prefix/share/icecast",
      'logdir'                    => '/var/log/icecast',
      'webroot'                   => "$prefix/share/icecast/web",
      'adminroot'                 => "$prefix/share/icecast/admin",
      'pidfile'                   => '/var/run/icecast',
      'alias'                     => [
        {
          'source'                => '/',
          'destination'           => '/status.xsl',
        },
      ],
      'ssl-certificate'           => "$prefix/share/icecast/icecast.pem",
    },
    'logging'                     => {
      'accesslog'                 => 'access.log',
      'errorlog'                  => 'error.log',
      'playlistlog'               => 'playlist.log',
      'loglevel'                  => 3,
      'logsize'                   => 10000,
      'logarchive'                => 1,
    },
    'security'                    => {
      'chroot'                    => 0,
      'changeowner'               => {
        'user'                    => 'icecast',
        'group'                   => 'icecast',
      },
    },
  }
}

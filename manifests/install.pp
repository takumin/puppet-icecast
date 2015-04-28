# == Class icecast::install
#
# This class is called from icecast for install.
#
class icecast::install {

  package { $::icecast::package_name:
    ensure => present,
  }
}

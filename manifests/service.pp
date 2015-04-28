# == Class icecast::service
#
# This class is meant to be called from icecast.
# It ensure the service is running.
#
class icecast::service {

  service { $::icecast::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}

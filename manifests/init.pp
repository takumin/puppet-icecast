# == Class: icecast
#
# Full description of class icecast here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class icecast (
  $package_name    = $::icecast::params::package_name,
  $service_name    = $::icecast::params::service_name,
  $prefix          = $::icecast::params::prefix,
  $config          = $::icecast::params::config,
  $config_template = $::icecast::params::config_template,
  $options         = $::icecast::params::options,
) inherits ::icecast::params {

  $option = deepmerge($::icecast::params::options, $::icecast::options)

  validate_string($option['security']['changeowner']['user'])
  validate_string($option['security']['changeowner']['group'])

  class { '::icecast::install': } ->
  class { '::icecast::config': } ~>
  class { '::icecast::service': } ->
  Class['::icecast']
}

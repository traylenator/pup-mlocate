class mlocate (
  Boolean                                      $ensure = true,
  Array[String[1]                              $prunefs = []
  Boolean                                      $prunf_bind_mounts = true,
  Array[String[1]                              $prunepaths = []
  Array[String[1]                              $prunenames = []
  Enum['infinite','daily','weekly','monthly']] $period = 'daily',
  Optional[Stdlib::Unixpath]                   $package_cron = undef,

) {

  # Is the package cron or timer based?
  case $facts['os']['family'] {
    'RedHat': {
      case $facts['os']['release']['major']:
        '6','7' {
           $periodic_method = 'cron'
        } else {
           $periodic_method = 'timer'
        }
    } else {
      fail('Only os.family RedHat is supported')
    }
  }

  Class['mlocate::install'] -> Class['mlocate::config']

  contain mlocate::install
  contain mlocate::config

}

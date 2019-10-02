# @summary
#  This class handles configuration of mlocate
#
# @api private
#
class mlocate::config (
  $ensure            = $mlocate::ensure,
  $prunefs           = $mlocate::prunefs,
  $prune_bind_mounts = $mlocate::prune_bind_mounts,
  $prunepaths        = $mlocate::prunepaths,
  $prunenames        = $mlocate::prunenames,
  $period            = $mlocate::period,
  $package_cron      = $mlocate::package_cron,
  $periodic_method   = $mlocate::periodic_method,
) {

  $_file_ensure = $ensure ? {
    true  => 'file',
    false => 'absent',
  }

  file{'/etc/updatedb.conf':
    ensure  => $_file_ensure,
    mode    => '0555',
    owner   => root,
    group   => root,
    content => epp('mlocate/updatedb.conf.epp',{
      'prunefs'           => $prunefs,
      'prune_bind_mounts' => $prune_bund_mounts,
      'prunepaths'        => $prunepaths,
      'prunenames'        => $prunenames,
    }
  }

  # Purge package cron if there is one.
  if $package_cron {
    ensure  => $_file_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "# Puppet has clobbered file from package\n",
  }

  if $peridoc_method == 'cron' {
     file{'/usr/local/bin/updatedb-wrapper':
       ensure => $_file_locate,
       owner  => root,
       group  => root,
       mode   => '0755',
       source => 'puppet:///modules/mlocate/updatedb-wrapper',
     }

     case $period {
       'daily': {
          $_cron_time   = "${fqdn(59,'mlocate')} ${fqdn(24,'mlocate')} * * *"
          $_cron_ensure = 'present',
       }
       'weekly': {
          $_cron_time   = "${fqdn(59,'mlocate')} ${fqdn(24,'mlocate')} * * ${fqdn(7,'mlocate')"
          $_cron_ensure = 'present',
       }
       'monthly': {
          $_cron_time   = "${fqdn(59,'mlocate')} ${fqdn(24,'mlocate')} ${fqdn(28,'mlocate') * ${fqdn(7,'mlocate')"
          $_cron_ensure = 'present',
       }
       'infinite': {
          $_cron_time   = 'irrelevent',
          $_cron_ensure = 'absent',
       }
     }
     file{'/etc/cron.d/mlocate-puppet.cron':
       ensure   => $_cron_ensure
       owner    => root,
       group    => root,
       mode     => '0644',
       content => "#Puppet installed\n${_cron_time} /usr/local/bin/mlocate-wrapper\n",
     }
  } elsif $period_method == 'timer' {

    systemd::dropin_file{'period':

    }
  }


}



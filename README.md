# Puppet module for mlocate

## Overview

* Install mlocate package
* Configures `/etc/updatedb.conf`
* Maintains a cron or timer to run mlocate.

## Example

Install mlocate and configure with default configuration.
```puppet
include mlocate
```

Configure everything we can.
```puppet
class{'mlocate':
  prunefs           => ['9p', 'afs', 'autofs', 'bdev'],
  prune_bind_mounts => true,
  prunenames        => ['.git', 'CVS'],
  prunepaths        => ['/afs', 'mnt' ],
  period            => 'daily',
  command           => '/usr/bin/local/custom-update',
}
```



# Class: sysctl
# Accept key: value hash with sysctl params. Apply them in runtime and save to sysctl.conf
# By default perform hiera_hash lookup for sysctl::params key.
# == Example:
# = manifest:
# include sysctl
# = hiera:
# sysctl::params:
#  'fs.file-max': '512000'
#  'net.core.somaxconn': '4096'
class sysctl (
    $params = hiera_hash('sysctl::params', {}),
){

case $operatingsystem {
    freebsd: {
      $apply_cmd="/sbin/sysctl -i -f /etc/sysctl.conf"
      }
    default: {
      $apply_cmd="/sbin/sysctl -p"
      }
}
    exec { 'sysctl_apply' :
        command     => $apply_cmd,
        refreshonly => true,
        returns     => ['0', '255'],
        logoutput   => 'on_failure',
    }

    # convert {a: b} to {a: {'value': b}}
    $final_params = add_sub_key($params, 'value')
    create_resources('sysctl::conf', $final_params)
}

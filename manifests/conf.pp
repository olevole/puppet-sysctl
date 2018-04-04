define sysctl::conf (
    $value,
    $key = $title,
) {
    include sysctl
    $context = '/files/etc/sysctl.conf'
    augeas { "sysctl_${key}" :
        context => $context,
        changes => "set ${key} '${value}'",
        notify  => Exec['sysctl_apply'],
    }
}

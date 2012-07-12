# HackThisSite Puppet Config

package { 'nginx':
    ensure => present,
    before => File['/etc/nginx/sites-available/hackthissite'],
}

file { '/etc/nginx/sites-available/hackthissite':
    ensure => file,
    mode => 600,
    source => '/data/configs/etc/nginx/sites-available/hackthissite',
}

service { 'nginx':
    ensure => running,
    enable => true,
}

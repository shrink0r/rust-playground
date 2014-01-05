Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

# set our default package provider
Package { provider => 'apt' }

# set projects base directory, which is also exported to nfs.
$hosting_root = "/home/vagrant/projects"

# define our concrete box configuration
class { 'boxes::devbox': }
-> rust-playground::basic { 'rust-playground.local': }

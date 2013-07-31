set['user'] = 'ubuntu'

set['localegen']['lang'] = [ 'en_GB.UTF-8 UTF-8', 'ru_RU.UTF-8 UTF-8' ]

set['locale']['lang'] = 'en_US.UTF-8'

set['zsh']['users'] = [ node['user'] ]

set['ohmyzsh']['theme'] = 'robbyrussell'
set['ohmyzsh']['users'] = [ node['user'] ]

set['mysql']['server_root_password'] = 'qweqwe'
set['mysql']['bind_address'] = '127.0.0.1'

set['rbenv']['root_path'] = '/opt/rbenv'
set['rbenv']['rubies'] = [ '1.9.3-p327' ]
set['rbenv']['global'] = '1.9.3-p327'
set['rbenv']['gems'] = {
  '1.9.3-p327' => [
    { 'name' => 'bundler' }
  ]
}

set['ruby_build']['upgrade'] = true

set['nginx']['version'] = '1.4.2'
set['nginx']['source']['url'] = "http://nginx.org/download/nginx-#{node['nginx']['version']}.tar.gz"
set['nginx']['init_style'] = 'runit'
set['nginx']['worker_processes'] = 2
set['nginx']['gzip'] = 'on'
set['nginx']['gzip_comp_level'] = 5

set['tz'] = 'Europe/Moscow'

set['mosh']['init_style'] = 'runit'

set['youroute']['deploy_user'] = node['user']

set['elasticsearch']['version'] = '0.90.1'

set['authorization']['sudo']['groups']       = ['sysadmin']
set['authorization']['sudo']['passwordless'] = true

set['logrotate']['global']['/var/log/nginx/*.log'] = {
    'missingok' => true,
    'daily' => true,
    'create' => '0660 root sysadmin',
    'rotate' => 30
}

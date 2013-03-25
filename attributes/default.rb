set['user'] = 'ubuntu'
set['localegen']['lang'] = [ "en_GB.UTF-8 UTF-8", "ru_RU.UTF-8 UTF-8" ]
set['locale']['lang'] = "en_US.UTF-8"
set['zsh']['users'] = [ node['user'] ]
set['ohmyzsh']['theme'] = "robbyrussell"
set['ohmyzsh']['users'] = [ node['user'] ]
set['mysql']['server_root_password'] = "qweqwe"
set['mysql']['bind_address'] = "127.0.0.1"
set['rbenv']['group_users'] = [ node['user'] ]
set['nginx']['worker_processes'] = 2
set['nginx']['gzip_comp_level'] = 5
set['fakes3']['root'] = '/mnt/fakes3'
set['fakes3']['port'] = 4567
set['tz'] = 'Europe/Moscow'
set['mosh']['init_style'] = 'runit'
set['youroute']['deploy_user'] = node['user']
set['elasticsearch']['version'] = "0.20.6"
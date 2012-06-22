set['user'] = node['user'] || 'ubuntu'
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
set['mosh']['version'] = "1.2"
set['mosh']['source_checksum'] = "8b2d346a2f0d560ceb2ca91ff396fa859f81bb321ebd8c26fc564db8b335433a"
set['mosh']['source_depends'] = case node['platform']
                                  when 'ubuntu', 'debian'
                                    %w( protobuf-compiler libprotobuf-dev libncurses5-dev pkg-config zlib1g-dev libutempter-dev libio-pty-perl)
                                  else
                                    []
                                  end
set['mosh']['init_style'] = 'runit'
set['youroute']['deploy_user'] = node['user']
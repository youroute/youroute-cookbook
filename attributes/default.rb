set['localegen']['lang'] = [ "en_GB.UTF-8 UTF-8", "ru_RU.UTF-8 UTF-8" ]
set['locale']['lang'] = "en_US.UTF-8"
set['zsh']['users'] = ['vagrant']
set['ohmyzsh']['theme'] = "robbyrussell"
set['ohmyzsh']['users'] = [ "vagrant" ]
set['mysql']['server_root_password'] = "qweqwe"
set['mysql']['bind_address'] = "127.0.0.1"
set['rbenv']['group_users'] = ['vagrant']
set['nginx']['worker_processes'] = 2
set['nginx']['gzip_comp_level'] = 5
set['fakes3']['root'] = '/mnt/fakes3'
set['fakes3']['port'] = 4567
set['tz'] = 'Europe/Moscow'
default['mosh']['version'] = "1.2"
default['mosh']['source_checksum'] = "8b2d346a2f0d560ceb2ca91ff396fa859f81bb321ebd8c26fc564db8b335433a"
default['mosh']['source_depends'] = case node['platform']
                                    when 'ubuntu', 'debian'
                                      %w( protobuf-compiler libprotobuf-dev libncurses5-dev pkg-config zlib1g-dev libutempter-dev libio-pty-perl)
                                    else
                                      []
                                    end
default['mosh']['init_style'] = 'runit'
# set[:postgresql][:password][:postgres] = "qweqwe"
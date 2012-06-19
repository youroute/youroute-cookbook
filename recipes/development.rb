#
# Cookbook Name:: youroute
# Recipe:: development
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe    "youroute::default"

node.load_attribute_by_short_filename("production", "youroute")

# vagrant ssh hangs up fix
template "/etc/rc.local" do
  source "rc.local"
  mode "755"
  owner "root"
  group "root"
end

gem_package "mysql"

mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

mysql_database_user 'developer' do
  connection mysql_connection_info
  password 'qweqwe'
  action :create
end

mysql_database_user 'developer' do
  connection mysql_connection_info
  password 'qweqwe'
  action :grant
end

bash "install ruby-1.9.3-p125-perf" do
  # code below executes "curl https://raw.github.com/gist/1688857/rbenv.sh | sh"
  code <<-EOH
    source /etc/zsh/zshenv
    source ~/.zshrc
    VERSION="1.9.3-p125"
    curl https://raw.github.com/gist/1688857/2-$VERSION-patched.sh > /tmp/$VERSION-perf
    rbenv install /tmp/$VERSION-perf
  EOH
  user 'rbenv'
  not_if { ruby_version_installed?('1.9.3-p125-perf') }
end

rbenv_global "1.9.3-p125-perf"
%w(bundler pry).each do |name|
  rbenv_gem name
end

['vagrant-deploy','vagrant-deploy.pub'].each do |name|
  cookbook_file "/home/vagrant/.ssh/#{name}" do
    source name
    owner "vagrant"
    group "vagrant"
    mode "600"
  end
end

bash "copy developer keys" do
  user "vagrant"
  cwd "/tmp/ssh-keys"
  code <<-EOH
  for file in *
  do
    if test ! -d "$file"
    then
      if test ! "$file" = "known_hosts" && test ! "$file" = "authorized_keys"
      then
        cp "$file" "/home/vagrant/.ssh/"
      fi
    fi
  done
  EOH
end

template "/tmp/wrap-ssh4git.sh" do
  source "wrap-ssh4git.sh.erb"
  owner "vagrant"
  mode 0700
end

####### TODO: move it into provider

youroute_path = "/srv/youroute"

git youroute_path do
  repository "git@github.com:youroute/youroute.git"
  branch "develop"
  user "vagrant"
  action :sync
  ssh_wrapper "/tmp/wrap-ssh4git.sh"
  not_if "test -d #{youroute_path}"
end

execute "bundle install --without production" do
  cwd youroute_path
  action :nothing
  subscribes :run, resources(:git => youroute_path), :immediately
end

# Rehash gems after bundle install for use their binaries
execute "rbenv rehash" do
  action :nothing
  subscribes :run, resources(:git => youroute_path), :immediately
end

execute "rake db:setup" do
  cwd youroute_path
  action :nothing
  subscribes :run, resources(:git => youroute_path), :immediately
end

#######

youroute_unicorn "youroute" do
  root "/srv/youroute/"
  runit_user "vagrant"
  runit_group "vagrant"
  server_names [ "dev.youroute.local", "youroute.local" ]
  serve_precompiled_assets false
  rails_env "development"
end

runit_service "guard-youroute" do
  options :rails_root => "/srv/youroute"
end
#
# Cookbook Name:: youroute
# Recipe:: development
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node['user'].replace 'vagrant' # replace value and change all relative variables

include_recipe 'youroute::rubybased'
include_recipe 'youroute::rubytest'

# vagrant ssh hangs up fix
template "/etc/rc.local" do
  source "rc.local"
  mode "755"
  owner "root"
  group "root"
end

bash "install ruby-#{node['ruby']['version']}-perf" do
  # code below executes "curl https://raw.github.com/gist/1688857/rbenv.sh | sh"
  code <<-EOH
    source /etc/zsh/zshenv
    source ~/.zshrc
    VERSION="#{node['ruby']['version']}"
    curl https://raw.github.com/gist/1688857/2-$VERSION-patched.sh > /tmp/$VERSION-perf
    rbenv install /tmp/$VERSION-perf
  EOH
  user 'rbenv'
  not_if { ruby_version_installed?("#{node['ruby']['version']}-perf") }
end

rbenv_global "#{node['ruby']['version']}-perf"
%w(bundler pry).each do |name|
  rbenv_gem name
end

bash "copy developer keys" do
  user node['user']
  cwd "/tmp/ssh-keys"
  code <<-EOH
  for file in *
  do
    if test ! -d "$file"
    then
      if test ! "$file" = "known_hosts" && test ! "$file" = "authorized_keys"
      then
        cp "$file" "/home/<%= node['user'] %>/.ssh/"
      fi
    fi
  done
  EOH
end

####### TODO: move it into provider

youroute_path = "/srv/youroute"

git youroute_path do
  repository "https://cb06038ca6b3250c9ebc30d74037ed2a4cfbab36:x-oauth-basic@github.com/youroute/youroute.git"
  branch "develop"
  user node['user']
  action :sync
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
  root "/srv/youroute"
  runit_user node['user']
  runit_group node['user']
  server_names [ "dev.youroute.dev", "youroute.dev" ]
  serve_precompiled_assets false
  rails_env "development"
end

runit_service "avia-faye" do
  options(
    :rails_root => "/srv/avia/"
  )
end

youroute_unicorn "avia" do
  root         "/srv/avia"
  rails_env    "development"
  serve_precompiled_assets false
  runit_user node['user']
  runit_group node['user']
  server_names [ "avia.youroute.dev" ]
end
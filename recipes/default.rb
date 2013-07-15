#
# Cookbook Name:: youroute
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'

include_recipe 'chef-client::delete_validation'
include_recipe 'runit'
include_recipe 'chef-client'

include_recipe 'users::sysadmins'
include_recipe 'youroute::localize'
include_recipe 'build-essential'
include_recipe 'git'
include_recipe 'zsh'
include_recipe 'oh-my-zsh'
include_recipe 'gemrc'
include_recipe 'youroute::mysql'
include_recipe 'nginx::source'
include_recipe 'timezone'
include_recipe 'mosh'
include_recipe 'logrotate'

[
  'htop', # for process monitoring
  'redis-server',
  'ntp'
].each do |name|
  package name do
    action :install
  end
end

# Dotfiles from youroute repo

remote_file "/home/#{node['user']}/.gitconfig" do
  source "https://raw.github.com/youroute/dotfiles/master/.gitconfig"
  user node['user']
  group node['user']
  mode "644"
end

remote_file "/home/#{node['user']}/.zshrc" do
  source "https://raw.github.com/youroute/dotfiles/master/.zshrc"
  user node['user']
  group node['user']
  mode "644"
end

remote_file "/home/#{node['user']}/.oh-my-zsh/themes/gallois.zsh-theme" do
  source "https://raw.github.com/youroute/dotfiles/master/.oh-my-zsh/themes/gallois.zsh-theme"
  user node['user']
  group node['user']
  mode "644"
end

execute "chmod -R -x /etc/update-motd.d/*"

template "/etc/update-motd.d/00-custom-header" do
  source "motd-custom-header.erb"
  mode "755"
end
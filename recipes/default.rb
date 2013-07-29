#
# Cookbook Name:: youroute
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
class Chef::Recipe
  include Utils
end

include_recipe 'apt'

include_recipe 'chef-client::delete_validation'
include_recipe 'runit'

include_recipe 'users::sysadmins'
include_recipe 'youroute::_localize'
include_recipe 'build-essential'
include_recipe 'git'
include_recipe 'zsh'
include_recipe 'oh-my-zsh'
include_recipe 'gemrc'
include_recipe 'youroute::_mysql'
include_recipe 'nginx::source'
include_recipe 'timezone'
include_recipe 'mosh'
include_recipe 'logrotate'

include_recipe 'java' # dependency of elasticsearch, but not required in cookbook
include_recipe 'elasticsearch'

include_recipe 'youroute::_customize'

install_packages([
  'htop', # for process monitoring
  'redis-server',
  'ntp'
])
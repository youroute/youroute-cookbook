#
# Cookbook Name:: youroute
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
require_recipe "apt"
require_recipe "locale-gen"
require_recipe "locale"
require_recipe "build-essential"
require_recipe "git"
require_recipe "zsh"
require_recipe "oh-my-zsh"
require_recipe "ruby_build"
require_recipe "rbenv"
require_recipe "gem-config"
require_recipe "database"
require_recipe "mysql"
require_recipe "mysql::server"
# require_recipe "postgresql::server"

[
  'console-cyrillic',
  ### this packages is nessesary for build nokogiri native extensions
  'libxml2-dev',
  'libxslt1-dev',
  ###
  'libsqlite3-dev', # this is for bundle install after rails new
  'imagemagick', # for paperclip
  'htop' # for process monitoring
].each do |name|
  package name do
    action :install
  end
end
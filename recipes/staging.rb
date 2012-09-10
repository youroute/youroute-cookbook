#
# Cookbook Name:: youroute
# Recipe:: server
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "youroute::default"

[
  # packages for capybara-webkit gem
  'xvfb',
  'libqt4-dev',
  'libqtwebkit-dev'
].each do |name|
  package name do
    action :install
  end
end

rbenv_ruby "1.9.3-p125"
rbenv_global "1.9.3-p125"
rbenv_gem "bundler"

{ "youroute-deploy" => "id_rsa", "youroute-deploy.pub" => "id_rsa.pub",
  "youroute-deploy" => "youroute-deploy", "youroute-deploy.pub" => "youroute-deploy.pub",
  "avia-deploy" => "avia-deploy", "avia-deploy.pub" => "avia-deploy.pub" }.each do |from, to|
  cookbook_file "/home/#{node['youroute']['deploy_user']}/.ssh/#{to}" do
    source from
    owner node['youroute']['deploy_user']
    group node['youroute']['deploy_user']
    mode "600"
  end
end

cookbook_file "/home/#{node['youroute']['deploy_user']}/.ssh/config" do
  source "ssh-config"
  owner node['youroute']['deploy_user']
  group node['youroute']['deploy_user']
  mode "755"
end

cookbook_file "/srv/youroute/current/htpasswd" do
  owner node['user']
  group node['user']
  mode "755"
end

youroute_unicorn "youroute" do
  root         "/srv/youroute/current"
  rails_env    "staging"
  runit_user   node['user']
  runit_group  node['user']
  server_names [ "dev.youroute.ru" ]
  password_protection true
end


logrotate_app "youroute" do
  cookbook "logrotate"
  path "/srv/youroute/current/log/staging.log"
  frequency "daily"
  rotate 30
  create "644 root adm"
end

runit_service "avia-resque" do
  options(
    :rails_root => "/srv/avia/current",
    :rails_env => "production"
  )
end

runit_service "avia-faye" do
  options(
    :rails_root => "/srv/avia/current"
  )
end

youroute_unicorn "avia-dev" do
  root         "/srv/avia-dev/current"
  rails_env    "production"
  serve_precompiled_assets true
  runit_user   node['user']
  runit_group  node['user']
  server_names [ "avia.youroute.ru" ]
end

runit_service "avia-dev-resque" do
  options(
    :rails_root => "/srv/avia-dev/current",
    :rails_env => "staging"
  )
end

runit_service "avia-dev-faye" do
  options(
    :rails_root => "/srv/avia-dev/current"
  )
end

youroute_unicorn "avia-dev" do
  root         "/srv/avia-dev/current"
  rails_env    "staging"
  serve_precompiled_assets true
  runit_user   node['user']
  runit_group  node['user']
  server_names [ "avia.dev.youroute.ru" ]
  password_protection true
end

# require_recipe "gitlabhq"

# youroute_unicorn "gitlabhq" do
#   root         "/home/gitlabhq/gitlabhq/current"
#   runit_user   "gitlabhq"
#   runit_group  "gitlabhq"
# end
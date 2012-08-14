#
# Cookbook Name:: youroute
# Recipe:: server
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "youroute::default"

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
  runit_user   "ubuntu"
  runit_group  "ubuntu"
  server_names [ "dev.youroute.ru" ]
  password_protection true
end

youroute_unicorn "avia" do
  root         "/srv/avia/current"
  rails_env    "development"
  serve_precompiled_assets false
  runit_user   "ubuntu"
  runit_group  "ubuntu"
  server_names [ "avia.dev.youroute.ru" ]
  password_protection true
end

# require_recipe "gitlabhq"

# youroute_unicorn "gitlabhq" do
#   root         "/home/gitlabhq/gitlabhq/current"
#   runit_user   "gitlabhq"
#   runit_group  "gitlabhq"
# end
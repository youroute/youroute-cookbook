#
# Cookbook Name:: youroute
# Recipe:: server
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "youroute::default"

node.load_attribute_by_short_filename("staging", "youroute") # TODO: place here include_attribute "staging"

rbenv_ruby "1.9.3-p125"
rbenv_global "1.9.3-p125"
rbenv_gem "bundler"

youroute_unicorn "youroute" do
  root         "/srv/youroute/current"
  runit_user   "ubuntu"
  runit_group  "ubuntu"
  server_names [ "dev.youroute.ru" ]
end

# require_recipe "gitlabhq"

# youroute_unicorn "gitlabhq" do
#   root         "/home/gitlabhq/gitlabhq/current"
#   runit_user   "gitlabhq"
#   runit_group  "gitlabhq"
# end
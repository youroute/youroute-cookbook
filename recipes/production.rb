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
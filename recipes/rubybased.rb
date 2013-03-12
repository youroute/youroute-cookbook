include_recipe "youroute::default"

require_recipe "ruby_build"
require_recipe "rbenv"
require_recipe "nginx::source"

[
  ### this packages is nessesary for build nokogiri native extensions
  'libxml2-dev',
  'libxslt1-dev',
  ###
  'libsqlite3-dev', # this is for bundle install after rails new
  'imagemagick', # for paperclip
].each do |name|
  package name do
    action :install
  end
end
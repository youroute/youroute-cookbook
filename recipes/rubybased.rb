include_recipe "youroute::default"

include_recipe "ruby_build"
include_recipe "rbenv::system"

install_packages([
  ### this packages is nessesary for build nokogiri native extensions
  'libxml2-dev',
  'libxslt1-dev',
  ###
  'libsqlite3-dev', # this is for bundle install after rails new
  'imagemagick', # for paperclip
])

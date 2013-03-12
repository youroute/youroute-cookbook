include_recipe "youroute::default"

[
  'apache2',
  'php5',
  'libapache2-mod-php5',
  'php5-gd',
  'php5-mysql'
].each do |name|
  package name do
    action :install
  end
end

execute "sudo service apache2 restart"

# create database pap
include_recipe "youroute::default"

install_packages([
  'apache2',
  'php5',
  'libapache2-mod-php5',
  'php5-gd',
  'php5-mysql'
])

execute "sudo service apache2 restart" # WHAT THA HACK?

# create database pap
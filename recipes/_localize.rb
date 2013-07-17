include_recipe 'locale-gen'
include_recipe 'locale'

install_packages([
  'console-cyrillic',
  'language-pack-ru'
])
# Copy dotfile settings from youroute dotfiles repo

remote_file "/home/#{node['user']}/.gitconfig" do
  source "https://raw.github.com/youroute/dotfiles/master/.gitconfig"
  user node['user']
  group node['user']
  mode "644"
end

remote_file "/home/#{node['user']}/.zshrc" do
  source "https://raw.github.com/youroute/dotfiles/master/.zshrc"
  user node['user']
  group node['user']
  mode "644"
end

remote_file "/home/#{node['user']}/.oh-my-zsh/themes/gallois.zsh-theme" do
  source "https://raw.github.com/youroute/dotfiles/master/.oh-my-zsh/themes/gallois.zsh-theme"
  user node['user']
  group node['user']
  mode "644"
end

execute "chmod -R -x /etc/update-motd.d/*"

template "/etc/update-motd.d/00-custom-header" do
  source "motd-custom-header.erb"
  mode "755"
end
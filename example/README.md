# Example

# Usage
```
vagrant up
ssh-add -K ~/.ssh/id_rsa
vagrant ssh
```

```
sudo yum -y install gcc make openssl-devel readline-devel zlib-devel git
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"' >> ~/.bash_profile
export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"
rbenv install 2.7.0
```

```
ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

```
bundle exec cap example inaminute:setup
bundle exec cap example deploy
```

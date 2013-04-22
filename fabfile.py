from fabric.api import *
env.hosts = ['root@t.vills.me']


def deploy():
    local('tar czf /tmp/deploy-app.tgz .')
    put('/tmp/deploy-app.tgz', '/tmp/')
    run('apt-get update -y > /dev/null')
    run('apt-get install ruby1.9.1-full rubygems curl libsqlite3-dev '
        'libmysqlclient-dev -y > /dev/null')
    run('stat /tmp/chef-omnibus.deb > /dev/null || '
        'curl -L -o /tmp/chef-omnibus.deb'
        '\'https://opscode-omnibus-packages.s3.amazonaws.com/debian/6/x86_64/'
        'chef_11.4.0-1.debian.6.0.5_amd64.deb\' ')
    run('dpkg -i /tmp/chef-omnibus.deb > /dev/null')
    run('gem install bundler')
    run('cat /root/.bashrc | grep export | grep gems > /dev/null || '
        'echo \'export PATH=/var/lib/gems/1.8/bin/:${PATH}\' >> ~/.bashrc')
    run('mkdir -p /var/www/.panel')
    with cd('/var/www/.panel'):
        run('tar xzf /tmp/deploy-app.tgz')
        run('bundle install')
    run('chef-solo -c /var/www/.panel/deploy/chef-solo.rb '
        '-j /var/www/.panel/deploy/chef-solo.json')
    local('rm -rf /tmp/deploy-app.tgz')

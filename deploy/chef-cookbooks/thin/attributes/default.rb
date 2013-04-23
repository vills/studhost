default['thin']['servers']      = 3
default['thin']['app_path']     = '/var/www'
default['thin']['environment']  = 'production'

default['thin']['max-conns']    = 1024
default['thin']['max-persistent-conns']  = 512
default['thin']['timeout']      = 30

default['thin']['apache']['domain']  = 'localhost'
default['thin']['apache']['error_log']  = '/var/log/apache2/thin.error.log'
default['thin']['apache']['access_log'] = '/var/log/apache2/thin.access.log'
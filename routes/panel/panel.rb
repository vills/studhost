#!/usr/bin/env ruby
#coding: UTF-8


before '/panel*' do
  authorize!
  @student = Student.get(session[:user]['id'])
  @sites = @student.sites if @student
end

get '/panel' do
  haml :'panel/index', :layout=>:layout_panel
end

get '/panel/site/add' do
  @title = "Добавление сайта"
  haml :'panel/site_add', :layout=>:layout_panel
end

post '/panel/site/add' do
  @depricated_domains = ['add', 'remove', 'delete', 'del', 'put', 'patch', 'get', 'post', 'thin', 'panel']
  @domain = params['domain'].strip

  @errors = Array.new()
  @errors << "Доменное имя не может быть пустым." if @domain == ''
  @errors << "Такое имя сайта запрещено к использованию." if @depricated_domains.include? @domain
  @errors << "Максимальная длина поддомена составляет 8 символов." if @domain.length > 8
  @errors << "Домен должен содержать только строчные буквы от 'a' до 'z', цифры '0-9' и знак тире '-'." if /^[a-zA-Z0-9-]*$/.match(@domain).nil?
  is_exists = @student.sites.first(:domain=>@domain)
  @errors << "Такое доменное имя уже зарегистрировано в системе." unless is_exists.nil?


  if @errors.count > 0
    haml :'panel/site_add', :layout=>:layout_panel
  else
    @password = Helpers::random_string(10)
    @newsite = @sites.create!(:domain=>@domain, :password=>@password)
    pp @newsite
    if APP_CONFIG['ENV'] == 'production'
      pp "sudo /usr/local/bin/studhosting-site-create.sh '#{@student.username}' '#{@domain}' '#{@password}'"
      `sudo /usr/local/bin/studhosting-site-create.sh '#{@student.username}' '#{@domain}' '#{@password}'`
      if $?.exitstatus > 0
        @errors << "Произошла внутренняя ошибка хостинга. Попробуйте позже"
        pp @errors
        @newsite.destroy! if @newsite
      end
    end

    if @errors.count > 0 
      haml :'panel/site_add', :layout=>:layout_panel
    else
      redirect "/panel/site/#{@domain}/info"
    end
  end
end



get '/panel/site/:domain/info' do
  @domain = params['domain'].strip
  @site = @student.sites.first(:domain=>@domain)
  if @site.nil?
    @message = "Нет такого домена"
    haml :send_message
  else
    haml :'panel/site_info', :layout=>:layout_panel
  end
end




get '/panel/site/:domain/filemanager*/DELETE' do |domain, dir|
  pp params
  filename = File.basename( request.fullpath.chomp('/DELETE') )
  pp request.fullpath.chomp('/DELETE').chomp("/#{filename}")

  path_del = params['splat'][0].gsub('//', '/').chomp('/')

  pp "sudo /usr/local/bin/studhosting-filemanager-delete.sh '#{@student.username}' '#{params['domain']}' '#{path_del}'"

  `sudo /usr/local/bin/studhosting-filemanager-delete.sh '#{@student.username}' '#{params['domain']}' '#{path_del}'`

  redirect request.fullpath.chomp('/DELETE').chomp("/#{filename}")
end

get '/panel/site/:domain/filemanager*' do |domain, dir|
  @path = '/' + dir.to_s.strip
  @path << '/' unless @path[-1, 1] == '/'
  @paths = @path.split('/').reject(&:empty?)

  @domain_path = APP_CONFIG['sitespath'] + "/#{@student.username}/#{domain}"
  @directory = "#{@domain_path + @path}".gsub('//', '/').chomp('/')

  @is_file = 0
  @filename = ""

  # generating directory listing
  begin
    if File.file?(@directory)
      @data = File.read(@directory)
      @is_file = 1
      @filename = File.basename(@directory)
      @directory = File.dirname(@directory)
    end

    @listing = {:dir=>Array.new, :file=>Array.new}
    Dir.foreach("#{@directory}") { |i| File.directory?("#{@directory}/#{i}") ? @listing[:dir] << i : @listing[:file] << i }
  rescue
    puts "File doesn't exist!"
  end

  @domain = params['domain'].strip
  @site = @student.sites.first(:domain=>@domain)
  if @site.nil?
    @message = "Нет такого домена"
    haml :send_message
  else
    haml :'panel/filemanager', :layout=>:layout_panel
  end
end

  
post '/panel/site/:domain/filemanager*' do |domain, dir|
  path_new = params['splat'][0].gsub('//', '/').chomp('/')

  @domain_path = APP_CONFIG['sitespath'] + "/#{@student.username}/#{domain}"
  directory = "#{@domain_path}/#{path_new}".gsub('//', '/').chomp('/')

  

  unless params['editor'].nil?
    tmpfilename = Helpers::random_string(32)
    File.open("/tmp/#{tmpfilename}", 'w') { |file| file.write(params['text']) }
    `sudo /usr/local/bin/studhosting-filemanager-edit.sh '#{@student.username}' '#{params['domain']}' '#{tmpfilename}' '#{path_new}'`
    File.delete("/tmp/#{tmpfilename}")
  else
    path_new = File.dirname(path_new) if File.file?(directory)
    `sudo /usr/local/bin/studhosting-filemanager-create.sh '#{@student.username}' '#{params['domain']}' '#{params['type']}' '#{path_new}/#{params['name'].strip}'`
  end

  redirect request.fullpath
end

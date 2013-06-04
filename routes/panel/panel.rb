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
  @depricated_domains = ['add', 'remove', 'delete', 'del', 'put', 'patch', 'get', 'post', 'thin']
  @domain = params['domain'].strip

  @errors = Array.new()
  @errors << "Доменное имя не может быть пустым." if @domain == ''
  @errors << "Такое имя сайта запрещено к использованию." if @depricated_domains.include? @domain
  @errors << "Домен должен содержать только строчные буквы от 'a' до 'z', цифры '0-9' и знак тире '-'." if /^[a-zA-Z0-9-]*$/.match(@domain).nil?
  is_exists = Site.first(:domain=>@domain)
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
      redirect "/panel/site/#{@domain}"
    end
  end
end




get '/panel/site/:domain' do
  @domain = params['domain'].strip
  @site = @student.sites.first(:domain=>@domain)
  if @site.nil?
    @message = "Нет такого домена"
    haml :send_message
  else
    haml :'panel/site_info', :layout=>:layout_panel
  end
end

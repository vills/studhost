#!/usr/bin/env ruby
#coding: UTF-8

get '/admin/users/approve/:id/false' do
  @s = Student.get(params['id'])
  if @s.nil?
    @message = "Нет такого студента"
    haml :send_message
  else
    send_email "#{@s.email.strip}", :subject=>"Ваша заявка была отклонена",
        :body=>"К сожалению, ваша заявка на регистрацию была отклонена одним из администраторов хостинга. Скорее всего вы что-то заполнили неправильно. Попробуйте ещё раз, если это правда необходимо."
    @s.destroy
    redirect "/admin"
  end
end

get '/admin/users/approve/:id/true' do
  @s = Student.get(params['id'])
  if @s.nil?
    @message = "Нет такого студента"
    haml :send_message
  else
    `sudo studhosting-user-create.sh`
    if $?.exitstatuss > 0
      @message = "В системе произошёл сбой. Стоит связаться с администратором."
      haml :send_message
    else
      send_email "#{@s.email.strip}", :subject=>"Ваша заявка была одобрена",
          :body=>"Администратор хостинга одобрил вашу заявку на регистрацию. Вы можете зайти в панель управления."
      @s.update(:approved=>true)
      redirect "/admin"
    end
  end
end

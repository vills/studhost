#!/usr/bin/env ruby
#coding: UTF-8

class Student
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, :required=>true, :index=>true,
                                :messages => {
                                  :presence  => "Нужно указать имя."
                                }
  property :email,      String, :required=>true, :index=>true, :unique=>true, :format => :email_address,
                                :messages => {
                                  :presence  => "Надо указать email.",
                                  :is_unique => "Такой email у нас уже есть. Может быть стоит попробовать восстановить пароль?",
                                  :format    => "Введённый email не похож на настоящий. Попробуйте ещё раз."
                                }
  property :password,   String, :length=>32, :required=>true,
                                :messages => {
                                  :presence  => "Если вы не выберите пароль, то мы потом не сможем вас авторизовать."
                                }
  property :approved,   Boolean,:default=>false, :index=>true
  property :emailappr,  Boolean,:default=>false
  property :emailapprhash, String, :length=>32, :index=>true

  belongs_to :speciality
end

class Speciality
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String, :required=>true, :index=>true, :length => 255

  has n, :students, :constraint => :destroy
  belongs_to :faculty
end

class Faculty
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String, :required=>true, :index=>true, :length => 255

  has n, :specialities, :constraint => :destroy
end

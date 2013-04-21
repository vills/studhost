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

  property :crypted_password,
                        String, :length=>32
  property :salt,       String, :length=>10

  property :approved,   Boolean,:default=>false, :index=>true
  property :emailappr,  Boolean,:default=>false
  property :emailapprhash,
                        String, :length=>32, :index=>true

  property :is_admin,   Boolean,:default=>false

  belongs_to :speciality

  attr_accessor :password
  validates_presence_of :password

  def password=(pass)
    @password = pass
    self.salt = Helpers::random_string(10) unless self.salt
    self.crypted_password = Student.encrypt(@password, self.salt)
  end

  def self.encrypt(pass, salt)
    Digest::MD5.hexdigest(pass + salt)
  end

  def self.authenticate(email, pass)
    s = Student.first(:email => email)
    return nil if s.nil?
    return s if Student.encrypt(pass, s.salt) == s.crypted_password
    nil
  end
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

require 'rubygems'
require 'sinatra'
require 'sinatra/contrib/all'
require 'pony'
require 'sqlite3'

configure do
        @dbase = SQLite3::Database.new 'public/customers.db' 
        @dbase.execute "create table if not exists 'customers' ('id' integer primary key autoincrement, 'Name' varchar, 'ArDate' varchar, 'Phone' integer, 'Barber' varchar, 'Color' varchar)"

end

get '/' do
  erb "<p>Hello Epta</p>"
end

get '/about' do
  @error= 'ATAKA-ATAKA'
  erb :about
end

get '/contacts' do
  erb :contacts 
end

get '/visit' do
  erb :visit
end

post '/visit' do

  @customer =params[:customer]
  @date = params[:date]
  @phone = params[:phone]
  @barber = params[:barber]
  @color = params[:color]
    hh = {:customer=>'Enter your name', 
        :phone=>'Enter your phone number', 
        :date=>'Enter your arrival time', 
        :color=>'Choose your color'}

        @error = hh.select {|key, value| params[key]==""}.values.join(", ")
      if @error != ''
            erb :visit
      else
          @dbase = SQLite3::Database.new 'public/customers.db' 
          @dbase.execute "insert into customers (Name, ArDate, Phone, Barber, Color) values ('#{@customer}', '#{@date}', '#{@phone}', '#{@barber}', '#{@color}')"

          @dbase.close
       
       erb "Your data are: #{@customer} | #{@date} | #{@phone} | #{@barber} | #{@color}\n"
      end 
  erb :visit
end

post '/contacts' do
  @email = params[:email]
  @report = params[:report]
    dh = {
        :email=>'Enter your email', 
        :report=>'Enter your message' 
          }
        @error = dh.select {|key, value| params[key]==""}.values.join(", ")
      if @error != ''
            erb :contacts
      else
      messages = File.open 'public/messages.txt', 'a'
      messages.puts "#{@email} | #{@report}\n"
      messages.close

      Pony.mail(:to => 'koq@nextmail.ru', :via => :sendmail, :from => "#{@email}", :body => "#{@report}" )
      erb "<p>Спасибо за ваш отзыв</p> <a href='/'>HOME</a>"

      end 

  end

get '/admen' do
  erb :admen
end

post '/admen' do
  
  @lohin = params[:lohin]
  @parol = params[:parol]

  if @lohin == 'admin' && @parol == 'admin'

  f = File.open 'public/customers.txt', 'r'
  @listok = f.read
  f.close
  else
    @irror = 'Access denied'
  end
end

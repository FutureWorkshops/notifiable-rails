require 'rubygems'
require 'grocer'
require 'benchmark'
require 'ruby-prof'

include Benchmark

namespace :apns do
	desc "Load tests the notification deliver against stub APNS server"
	task :load_test => :environment do
		Rails.env = "test"
    
		ActiveRecord::Base.establish_connection('load_test_sqlite')
    
		#ActiveRecord::Base.establish_connection('load_test_pg')
		#ActiveRecord::Base.establish_connection('load_test_mysql')
    
		test_apns
	end
end

private 
def test_apns

  RubyProf.start

	Notifiable.configure do |config|
		config.apns_certificate = nil
		config.apns_gateway = ENV["NOTIFIABLE_APNS_STUB_HOST"] || "localhost"
		config.apns_passphrase = nil
	end

	notification = Notifiable::Notification.create(:message => 'Test notification')
	user = User.create({ :email => 'test@example.com' })
	device_token = Notifiable::DeviceToken.create(:token => '852a38d14b5e6df4168d3f7f41b38f6627b2cc0605bd53266f6d6fe8332738', :provider => :apns, :user_id => 'test@example.com')

	iterations = 10
	batch_size = 10000

	tt = Benchmark::Tms.new

	Benchmark.benchmark(CAPTION, 9, FORMAT, "> TOTAL: ", "> BATCH:") do |x|
		iterations.times do ;

			tt = tt + x.report("#{batch_size}:") {
				Notifiable.batch do |batch|
					batch_size.times do ;
						batch.add(notification, user)			
					end
				end
			}

		end
		[tt, tt / iterations]
	end
	device_token.destroy
	user.destroy
	notification.destroy
  
  result = RubyProf.stop
  printer = RubyProf::GraphHtmlPrinter.new(result)
  printer.print(File.new('/tmp/profile.html', 'w'), :min_percent => 2)

end

# Hack to disable server cert verfification

module Grocer
  class SSLConnection
   
    def connect
      context = OpenSSL::SSL::SSLContext.new
      context.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @sock            = TCPSocket.new(gateway, port)
      @sock.setsockopt   Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true
      @ssl             = OpenSSL::SSL::SSLSocket.new(@sock, context)
      @ssl.sync        = true
      @ssl.connect
    end

  end
end



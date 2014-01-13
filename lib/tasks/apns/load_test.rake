require 'rubygems'
require 'grocer'
require 'benchmark'

include Benchmark

namespace :apns do
	desc "Load tests the notification deliver against stub APNS server"
	task :load_test => :environment do
		Rails.env = "test"
		ActiveRecord::Base.establish_connection('production')
		test_apns
    	ActiveRecord::Base.establish_connection(ENV['RAILS_ENV']) 
	end
end

private 
def test_apns

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
	log_every = 1000
	n = batch_size / log_every

	tt = Benchmark::Tms.new

	Benchmark.benchmark(CAPTION, 9, FORMAT, "> TOTAL: ", "> BATCH:") do |x|
		iterations.times do ;

			Notifiable.batch do |batch|
				n.times do ;
					tt = tt + x.report("#{log_every}:") { 
						log_every.times do ;
							batch.add(notification, user)			
						end
					}
				end
			end
		end
		[tt, tt / iterations]
	end
	device_token.destroy
	user.destroy
	notification.destroy

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



require "grocer"
require "gcm"

module Notifiable
  
  class Engine < ::Rails::Engine
    isolate_namespace Notifiable
    
    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
    
  end

end

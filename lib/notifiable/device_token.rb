# frozen_string_literal: true

require 'rgeo'
require 'rgeo-activerecord'

RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
  config.default = RGeo::Geographic.spherical_factory(srid: 4326)
end

module Notifiable
  class DeviceToken < ActiveRecord::Base
    self.table_name_prefix = 'notifiable_'

    belongs_to :app, class_name: 'Notifiable::App'
    has_many :notification_statuses, class_name: 'Notifiable::NotificationStatus'

    validates :token, presence: true, uniqueness: { scope: :app, case_sensitive: false }
    validates :provider, presence: true
    validates :app, presence: true
    validates :language, length: { in: 2..3 }, allow_blank: true # ISO 639-1 or ISO 6369-2 language code
    validates :country, length: { is: 2 }, allow_blank: true # ISO 3166-1 alpha-2 country code

    scope :nearby, ->(lon, lat, radius) { where('ST_DWithin(lonlat, ST_MakePoint(?,?), ?)', lon, lat, radius) }

    before_save :downcase_language, :downcase_country

    private

    def downcase_language
      language&.downcase!
    end

    def downcase_country
      country&.downcase!
    end
  end
end

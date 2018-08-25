# frozen_string_literal: true

require 'active_record'

class ActiveRecord::Base
  def self.bulk_insert!(record_list)
    return if record_list.empty?

    adapter_type = connection.adapter_name.downcase.to_sym
    case adapter_type
    when :postgresql
      connection.execute(postgresql_bulk_insert_sql(record_list))
    else
      default_bulk_insert(record_list)
    end
  end

  protected

  def self.convert_record_list(record_list)
    key_list = record_list.map(&:keys).flatten.uniq.sort

    value_list = record_list.map do |rec|
      list = []
      key_list.each { |key| list << ActiveRecord::Base.connection.quote(rec[key]) }
      list
    end

    [key_list, value_list]
  end

  def self.postgresql_bulk_insert_sql(record_list)
    key_list, value_list = convert_record_list(record_list)
    "INSERT INTO #{table_name} (#{key_list.join(', ')}) VALUES #{value_list.map { |rec| "(#{rec.join(', ')})" }.join(' ,')}"
  end

  def self.default_bulk_insert(record_list)
    ActiveRecord::Base.transaction do
      record_list.each { |record| Notifiable::NotificationStatus.create(record) }
    end
  end
end

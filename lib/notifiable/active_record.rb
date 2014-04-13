class ActiveRecord::Base

  def self.bulk_insert!(record_list)
    return if record_list.empty?
    
    adapter_type = connection.adapter_name.downcase.to_sym
    case adapter_type
    when :mysql
      raise NotImplementedError, "Not implemented type '#{adapter_type}'"
    when :sqlite
      sqlite_bulk_insert(record_list)
    when :postgresql
      postgresql_bulk_insert(record_list)
    when :oracle_enhanced
      oracle_bulk_insert(record_list)
    else
      raise NotImplementedError, "Unknown adapter type '#{adapter_type}'"
    end
    
  end
  
  protected
  def self.convert_record_list(record_list)
    key_list = record_list.map(&:keys).flatten.uniq.sort

    value_list = record_list.map do |rec|
      list = []
      key_list.each {|key| list <<  ActiveRecord::Base.connection.quote(rec[key]) }
      list
    end

    return [key_list, value_list]
  end
  
  def self.sqlite_bulk_insert(record_list)
    self.create record_list
  end
  
  def self.postgresql_bulk_insert(record_list)
    key_list, value_list = convert_record_list(record_list)        
    sql = "INSERT INTO #{self.table_name} (#{key_list.join(", ")}) VALUES #{value_list.map {|rec| "(#{rec.join(", ")})" }.join(" ,")}"
    self.connection.insert_sql(sql)
  end
  
  def self.oracle_bulk_insert(record_list)
    key_list, value_list = convert_record_list(record_list)        
    sql = "INSERT INTO #{self.table_name} (#{key_list.join(", ")}) VALUES (bind variables #{value_list.map {|rec| "(#{rec.join(", ")})" }.join(" ,")})"
    self.connection.insert_sql(sql)
  end
  
end
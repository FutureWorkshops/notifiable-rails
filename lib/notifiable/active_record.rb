class ActiveRecord::Base

  def self.bulk_insert!(record_list)
    return if record_list.empty?
    
    adapter_type = connection.adapter_name.downcase.to_sym
    case adapter_type
    when :mysql
      raise NotImplementedError, "Not implemented type '#{adapter_type}'"
    when :sqlite
      self.create(record_list)
    when :postgresql
      self.connection.execute(postgresql_bulk_insert_sql(record_list))      
    when :oracleenhanced
      self.connection.execute(oracle_bulk_insert_sql(record_list))
    else
      raise NotImplementedError, "Unknown adapter type '#{adapter_type}' for ActiveRecord::Base.bulk_insert!"
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
  
  def self.postgresql_bulk_insert_sql(record_list)
    key_list, value_list = convert_record_list(record_list)        
    "INSERT INTO #{self.table_name} (#{key_list.join(", ")}) VALUES #{value_list.map {|rec| "(#{rec.join(", ")})" }.join(" ,")}"
  end
  
  def self.oracle_bulk_insert_sql(record_list)
    key_list, value_list = convert_record_list(record_list)  
    
    inserts = []
    value_list.each do |rec|
      inserts << "INTO #{self.table_name} (#{key_list.join(", ")}) VALUES (#{rec.join(", ")})"
    end 
    
    "INSERT ALL #{inserts.join(' ')}"   
  end
  
end
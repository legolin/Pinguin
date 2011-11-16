module Pinguin
  class Host < CassandraRecord
    
    def self.get_by_host_id(some_id)
      connection.get(:hosts, some_id.to_s)
    end

    def self.all
      connection.get_range(:hosts)
    end

  end
end
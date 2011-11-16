module Pinguin
  class CassandraRecord
    def self.connection
      @@connection ||= self.setup_connection
    end
    def self.setup_connection
      cassandra_config_file = File.join(BASE_DIR, 'config', 'cassandra.yml')
      cassandra_config = YAML::load_file(cassandra_config_file)[ENV['RACK_ENV']]
      client = Cassandra.new(cassandra_config['keyspace'], "#{cassandra_config['host']}:9160")
      client.login!(cassandra_config['username'], cassandra_config['password']) if cassandra_config['username']
      client
    end
    def connection
      CassandraRecord.connection
    end

    def self.cached_get(column_family, key, options = {})
      @@cached_data ||= {}
      cache_key = "#{column_family}.#{key}.#{options.to_s}"
      
      if @@cached_data[cache_key].nil? || @@cached_data[cache_key]['expires'] < Time.now
        cache_expiration = Time.now + 300
        @@cached_data[cache_key] ||= {}
        @@cached_data[cache_key]['expires'] = cache_expiration
        @@cached_data[cache_key]['data'] = connection.get(column_family, key, options)
      end
      @@cached_data[cache_key]['data']
    end

  end
end
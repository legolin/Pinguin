module Pinguin

  class Penguin

    def initialize(config_path, cassandra_connection)
      # Get configs
      @configs = YAML::load(File.open(config_path))
      @@cassandra_connection = cassandra_connection
    end

    def connection
      @@cassandra_connection
    end

    def run
      # Create request object for each item in monitor-config
      requests = {}
      @configs.each do |name, config|

          # Create new request
          request = Typhoeus::Request.new config['url'],
                          :method         => :get,
                          :headers        => {:Accept => 'text/html'},
                          :timeout        => 10000,
                          :cache_timeout  => 15

          # Set authentication if needed
          if config.has_key?('http-auth')
            request.username = config['http-auth']['username']
            request.password = config['http-auth']['password']
          end

          # Post each uri to the hosts table
          connection.insert(:hosts, name, {'uri' => config['url']})

          # Set on-complete handler
          request.on_complete do |response|
            puts "'#{config['url']}'"
            connection.insert(:requests, config['url'], Time.now.utc.to_i => {'time' => response.time, 'success' => response.success?})
          end
          requests[name] = request
      end

      hydra = Typhoeus::Hydra.new

      while true do
        requests.each do |name, request|
          hydra.queue(request)
        end
        hydra.run
        sleep 5 * 60
      end
    end
    
    def self.connection
      @cassandra_connection
    end

  end

end
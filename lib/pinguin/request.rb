module Pinguin
  class Request < CassandraRecord
    
    def self.data_points_by_host(host_id = nil, options = {})
      from = options[:from] || (Time.now - 365 * 86400)
      to = options[:to] || Time.now

      host = Host.get_by_host_id(host_id)
      url = host['uri']

      data = cached_get(:requests, url, :start => from.to_time.to_i, :finish => to.to_time.to_i)
      data.collect{|key, item| [key.to_i * 1000, item['time'].to_f]}
    end

    def self.summary(host_id = nil, options = {})

      from = options[:from] || (Time.now - 365 * 86400)
      to = options[:to] || Time.now

      host = Host.get_by_host_id(host_id)
      url = host['uri']
      
      data = cached_get(:requests, url, :start => from.to_time.to_i, :finish => to.to_time.to_i)

      mapped_data = {'successes' => 0, 'total_time' => 0, 'total_requests' => 0}
      data.each do |key ,val|
        mapped_data['successes'] += 1 if val['success'] == 'true'
        mapped_data['total_time'] += val['time'].to_f
        mapped_data['total_requests'] += 1
      end

      {
        'uptime' => mapped_data['total_requests'] == 0 ? '0' : mapped_data['successes'] / mapped_data['total_requests'],
        'average_request_time' => mapped_data['total_requests'] == 0 ? '0' : mapped_data['total_time'] / mapped_data['total_requests']
      }
    end

  end
end
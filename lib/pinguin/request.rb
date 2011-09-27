module Pinguin
  class Request
    include Mongoid::Document    
    field :time, :type => Integer
    field :success, :type => Boolean
    field :timestamp, :type => DateTime, :default => lambda{ Time.now.utc }
    belongs_to :host, :class_name => "Pinguin::Host"

    def self.data_points_by_host(host_id = nil, options = {})
      from = options[:from] || (Time.now - 365 * 86400)
      to = options[:to] || Time.now
      date_range = (from..to)
      data = self.where(:host_id => host_id).where(:timestamp.gte => from, :timestamp.lte => to)
      data.collect{|item| [item['timestamp'].to_i * 1000, item['time']]}
    end

    def self.summary(host_id = nil)
      host_id = host_id.to_s
      map     = "
        function () {
          emit(this.host_id, {successes:this.success, totalTime:this.time, totalRequests: 1});
        }
      "
      reduce  = "
        function (key, values) {
            var result = {successes: 0, totalTime: 0, totalRequests:0};
            values.forEach(function(doc) {
              if(+doc.successes > 0) result.successes += doc.successes;
              result.totalTime += doc.totalTime
              result.totalRequests += doc.totalRequests
            });
            return result;
        }
      "
      finalize = "
        function(k, doc) {
          var final_result = {avgRequestTime: 0, uptime: 0}
          final_result.uptime = doc.successes / doc.totalRequests;
          final_result.avgRequestTime = doc.totalTime / doc.successes;
          return final_result;
        }
      "
      options = {:finalize => finalize, :out => "summary_by_host"}
      summary  = collection.map_reduce(map, reduce, options )
      summary.find.inject({}) {|h, entry| h[entry['_id'].to_s] = entry['value']; h }[host_id]
    end

  end
end
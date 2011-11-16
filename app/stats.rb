require 'lib/pinguin/cassandra'
require 'lib/pinguin/request'
require 'lib/pinguin/host'

set :views, File.dirname(__FILE__) + '/views'
set :public, './public'

get '/' do
  @summaries = {}
  @hosts = Pinguin::Host.all
  @hosts.each do |key, value|
    @summaries[key.to_s] = Pinguin::Request.summary(key.to_s)
  end 
  @datas = @hosts.collect{|key, value| {:label => value['uri'], :data => Pinguin::Request.data_points_by_host(key, :from => Time.now - 14*86400)}}
  haml :index
end

get '/hosts' do
  @hosts = Pinguin::Host.all
  @hosts.to_json
end

get '/hosts/:host_id/summary' do
  @summary = Pinguin::Request.summary(params[:host_id])
  puts params[:host_id]
  @summary.to_json
end
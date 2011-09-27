require 'lib/pinguin/request'
require 'lib/pinguin/host'

set :views, File.dirname(__FILE__) + '/views'
set :public, File.dirname(__FILE__) + '/public'

get '/' do
  @hosts = Pinguin::Host.all
  @summaries = @hosts.inject({}) {|h, item| h[item._id] = Pinguin::Request.summary(item._id); h} 
  @datas = @hosts.collect{|host| {:label => host.url, :data => Pinguin::Request.data_points_by_host(host._id.to_s, :from => Time.now - 14*86400)}}
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
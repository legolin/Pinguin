require 'lib/pinguin/request'
require 'lib/pinguin/host'


get '/hosts' do
  @hosts = Pinguin::Host.all
  @hosts.to_json
end

get '/hosts/:host_id/summary' do
  @summary = Pinguin::Request.summary(params[:host_id])
  puts params[:host_id]
  @summary.to_json
end
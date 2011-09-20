module Pinguin
  class Request
    include Mongoid::Document    
    field :time, :type => Integer
    field :success, :type => Boolean
    field :timestamp, :type => DateTime, :default => lambda{ Time.now.utc }
    belongs_to :host, :class_name => "Pinguin::Host"
  end
end
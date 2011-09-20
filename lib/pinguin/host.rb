module Pinguin
  class Host
    include Mongoid::Document
    field :url, :type => String
    field :name, :type => String
    has_many :requests, :class_name => "Pinguin::Request"
  end
end
class Discount < ActiveRecord::Base
  attr_accessible :code, :expiration, :limit, :value
end

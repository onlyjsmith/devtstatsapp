class Funder < ActiveRecord::Base
  has_many :funding_groups
  has_many :projects, :through => :funding_groups
end

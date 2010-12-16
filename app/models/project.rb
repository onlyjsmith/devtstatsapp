class Project < ActiveRecord::Base
  has_many :devtcharges
  has_many :pipelines

  has_many :funding_groups
  has_many :funders, :through => :funding_groups
end

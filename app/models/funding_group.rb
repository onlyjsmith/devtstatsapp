class FundingGroup < ActiveRecord::Base
  belongs_to :project
  belongs_to :funder
end

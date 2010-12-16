class Project < ActiveRecord::Base
  has_many :devtcharges
  has_many :pipelines

  has_many :funding_groups
  has_many :funders, :through => :funding_groups

  def duration
    # project = Project.find(_by_number(self.id)
    @earliest = '1/1/2099'.to_date; @latest = '1/1/1999'.to_date # TODO make this neater
    self.pipelines.each do |i|
      unless i.nil?
        date = Date.new(i.year, i.month)
        date = (date >> 1) - 1
        # puts date.to_s + " at " + i.stage.to_s
        if date <= @earliest.to_date
          then @earliest = date
        end
        if date >= @latest.to_date
          then @latest = date
        end
      end
    end
    return @duration = (@latest.month - @earliest.month) + 12 * (@latest.year - @earliest.year)
  end


end

class BuildController < ApplicationController
  require 'csv'
  # Lots of this might be irrelevant - was originally copied verbatim from the Ruby app

  def import_project_numbers
    file = CSV.open('public/import/dump.csv')
    # file.shift
    file.each do |p|
      # ap p[0]
      # add 'unless' to check if project already exists
      unless Project.find_by_number(p)
        # puts p
        # unless Project.find_by_number(p).number.nil?
          Project.create(:number => p[0])
        # end
      end 
    end
  end
  
  def import_project_names
    file = CSV.read('public/import/pipeline_basic.csv')
    ap file.first  
    file.shift
    puts "Shifted?"
    ap file.first
    file.each do |f|
      r = Project.find_by_number(f[4])
      r.title = f[6]
      r.save
    end
  end

  def import_pipelines
    file = CSV.read('public/import/pipeline_basic.csv')
    file.shift
    file.each do |f|
      ap f
      p = Project.find_by_number(f[4]).id
      Pipeline.create(:year => f[1], :month => f[2], :stage => f[3], :lead => f[5], :programme => f[7], :funder => f[8], :budget => f[9], :stafftime => f[10], :project_id  => p)
    end
  end

  def import_devtcharges
    file = CSV.read('public/import/devtcharge_basic.csv')
    file.shift
    file.each do |f|
      p = Project.find_by_number(f[2]).id
      Devtcharge.create(:year => f[1], :grossdevt => f[3], :recovered => f[4], :netdevt  => f[5], :project_id => p)
    end
  end


  def unique_projects_from_pipeline
    file = CSV.read('public/import/pipeline_basic.csv')
    list = []
    file.each do |rec|
      list << rec[4]
    end
    # ap list
    @unique_projects_from_pipeline = []
    list.each do |u|
      unless @unique_projects_from_pipeline.include?(u) 
        @unique_projects_from_pipeline << u
      end
    end   
    # ap @unique_projects_from_pipeline

    # This exported the list of uniques for testing
    # CSV.open("unique_projects_from_pipeline.csv", "wb") do |csv|
    #   # @unique.each do |u|
    #     csv << @unique
    #   # end
    # end
  end

  def unique_projects_from_devtcharge
    file = CSV.read('public/import/devtcharge_basic.csv')
    list = []
    file.each do |rec|
      list << rec[2]
    end
    # ap list
    @unique_projects_from_devtcharge = []
    list.each do |u|
      unless @unique_projects_from_devtcharge.include?(u) 
        @unique_projects_from_devtcharge << u
      end
    end   
    # ap @unique_projects_from_devtcharge

  end

  def unique_combined
    @unique = []
    @unique_projects_from_devtcharge.each do |d|
      unless @unique.include?(d)
        # ap d
        @unique << d
      end
    end
    @unique_projects_from_pipeline.each do |p|
      unless @unique.include?(p)
        @unique << p
      end
    end 
    @unique.slice!(0)
    # ap @unique
  
    CSV.open('public/import/dump.csv','w') do |f|
      @unique.each do |u|
        row = []
        row[0] = u
        f << row
      end
    end
  end
  
  def project_list_individual_funders(project_number)
    p = Project.find_by_number(project_number)
    # ap p
    p.pipelines.each do |l|
      # puts l.funder
      split = l.funder.split(',')
      stripped_split = []
      split.each do |a|
        a = a.strip
        stripped_split << a
      end
      # ap split
      ap stripped_split
    end
  end

  def all_list_unique_funders
    p = Pipeline.all
    # ap p
    @unique_funders = []
    p.each do |l|
      # puts l.funder
      # ap l.funder#.size

        if l.funder.nil? then split = 'None' else split = l.funder.split(',') end
        stripped_split = []
        if split.is_a?(Array) 
          then 
          # ap split
          split.each do |a|
            a = a.strip
            stripped_split << a
          end        
        end 

      # ap split
      # ap stripped_split

      stripped_split.each do |u|
        unless @unique_funders.include?(u) 
          @unique_funders << u
        end
      end
    end
    ap @unique_funders

    CSV.open('public/import/unique_funders.csv','w') do |f|
      @unique_funders.each do |u|
        row = []
        row[0] = u
        f << row
      end
    end 
  end

  def all_add_funders_to_db
    file = CSV.read('public/import/unique_funders.csv')
    file.each do |line|
      # break
      # puts line
      # ap line
      Funder.create(:name => line[0])
      # this fails because the project_id isn't known
      # break
    end
  end

  def all_add_funders_to_projects
    Project.all.each do |p|
      next if p.pipelines.nil? # skip if it's a project number without pipelines
      l = p.pipelines.last # take the state of the final pipeline
      next if l.nil? # skip if the final pipeline is blank
      if l.funder.nil? then split = 'None' else split = l.funder.split(',') end
        stripped_split = []
        if split.is_a?(Array) 
          then 
          # ap split
          split.each {|a| stripped_split << a.strip}
        end
      # ap l
      # ap p
      # fg = FundingGroup.create(:project_id => p.id)
      fg = FundingGroup.find_by_project_id(p.id)
      puts "Project_id = " + p.id.to_s
      stripped_split.each do |ss|
        f = Funder.find_by_name(ss)
        ap f.id
        ap p.id
        # Create a new Funder, unless already exists
        # Link the new Funder to the Project via the FundingGroup table: take Funder's id and Project's id (which is p!)
        fg = FundingGroup.create(:project_id => p.id, :funder_id => f.id)
        ap fg
        # Funder.create(:funding_group_id  => fg.id, :name => ss)
      end
      # break
    end
  end

  def change_blank_project_titles
    all = Project.all
    all.each do |p|
      if p.title.nil?
        p.title = "Blank"
        p.save
      end
    end
  end
  
  # This bit does all the heavy lifting!
  def build_database
    # self.connect_mysql
    # self.create_db # TODO: Recreate this from schema.rb in Rails app
    self.unique_projects_from_pipeline
    self.unique_projects_from_devtcharge
    self.unique_combined
    self.import_project_numbers
    self.import_project_names
    self.import_pipelines
    self.import_devtcharges
    self.all_list_unique_funders
    self.change_blank_project_titles
  end
  
end

class Project < ActiveRecord::Base
  has_many :issues
end

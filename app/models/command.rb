class Command < ActiveRecord::Base
  belongs_to :user
  attr_accessor :number

end

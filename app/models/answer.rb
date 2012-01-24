
#### Need this for db:rollback as it is used in down migration ####

class Answer < ActiveRecord::Base
  belongs_to :question
end

class UserComedyTag < ApplicationRecord
  belongs_to :user
  belongs_to :comedy_tag
end

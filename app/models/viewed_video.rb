class ViewedVideo < ApplicationRecord
  belongs_to :user
  belongs_to :alarm
end

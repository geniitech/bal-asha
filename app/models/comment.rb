# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  person_id        :integer
#  content          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :commentable
  belongs_to :person

  validates :person, :commentable, :content, presence: true
end

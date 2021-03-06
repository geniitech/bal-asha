# == Schema Information
#
# Table name: disbursements
#
#  id                :integer          not null, primary key
#  disbursement_date :date
#  remarks           :text
#  deleted_at        :datetime
#  person_id         :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Disbursement < ActiveRecord::Base
  acts_as_paranoid

  include Transactionable

  belongs_to :creator, class_name: Person, foreign_key: 'person_id'

  validates :disbursement_date, :person_id, :transaction_items, presence: true
  validate :stock_remains_positive

  delegate :email, to: :creator, prefix: true, allow_nil: true

  ransacker :disbursement_date do
    Arel.sql('disbursement_date')
  end

  after_create :remove_from_stock
  before_destroy :add_to_stock

  private
    def stock_remains_positive
      self.transaction_items.each do |transaction_item|
        item = transaction_item.item
        if item.stock_quantity - transaction_item.quantity < 0
          errors.add(:base, "Not enough #{item.name}")
        end
      end
    end
end

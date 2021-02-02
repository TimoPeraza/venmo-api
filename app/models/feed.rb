# == Schema Information
#
# Table name: feeds
#
#  id          :bigint           not null, primary key
#  payment_id  :bigint           not null
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_feeds_on_payment_id  (payment_id)
#
class Feed < ApplicationRecord
  belongs_to :payment

  validates :description, presence: true
end

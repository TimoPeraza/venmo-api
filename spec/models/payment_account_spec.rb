# == Schema Information
#
# Table name: payment_accounts
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  balance    :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_payment_accounts_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe PaymentAccount, type: :model do
  subject { build :payment_account }

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:balance).is_less_than_or_equal_to(1000) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end

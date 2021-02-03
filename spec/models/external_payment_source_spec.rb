# == Schema Information
#
# Table name: external_payment_sources
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_external_payment_sources_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe ExternalPaymentSource, type: :model do
  subject { build :external_payment_source }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end

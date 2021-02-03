describe PaymentService do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:external_payment_source)  { create(:external_payment_source, user: user) }
  let!(:payment_account_one) { create(:payment_account, user: user) }
  let!(:payment_account_two) { create(:payment_account, user: friend) }
  let!(:payment_account_three) { create(:payment_account, user: other_user) }
  let!(:friendship) do
    create(:friendship, first_friend: user, second_friend: friend)
  end
  let(:description) { 'thanks for lend me money bro!' }

  subject(:payment_service) do
    PaymentService.new(user, user_friend, amount, description).transfer_money
  end

  describe 'when the paramters are valid' do
    let(:user_friend) { friend }

    describe 'when the amount is greater than user balance' do
      let(:amount) { 550 }

      it 'transfers from external payment source' do
        expect_any_instance_of(MoneyTransferService).to receive(:transfer).with(50)
        payment_service
      end

      it 'increase friends balance' do
        expect { payment_service }.to change { friend.payment_account.reload.balance }.from(500).to(1050)
      end
    end
  
    describe 'when the amount is less than user balance' do
      let(:amount) { 300 }
  
      it 'decreases users balance' do
        expect { payment_service }.to change { user.payment_account.reload.balance }.from(500).to(200)
      end
      it 'increase friends balance' do
        expect { payment_service }.to change { friend.payment_account.reload.balance }.from(500).to(800)
      end
    end
  end

  describe 'when the parameters are not valid' do
    describe 'when the amount is a negative value' do
      let(:user_friend) { friend }
      let(:amount) { -100 }

      it 'raises a negative amount error' do
        expect { payment_service }.to raise_error(Payments::NegativeAmountError)
      end
    end

    describe 'when the user is not a friend' do
      let(:user_friend) { other_user }
      let(:amount) { 100 }

      it 'raises a not users friendship error' do
        expect { payment_service }.to raise_error(Payments::NotUsersFriendshipError)
      end
    end
  end
end

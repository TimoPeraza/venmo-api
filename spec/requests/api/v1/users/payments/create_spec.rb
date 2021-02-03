describe 'POST api/v1/users/:id/payment', type: :request do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:other_friend) { create(:user) }
  let!(:user_payment_account) { create(:payment_account, user: user) }
  let!(:friend_payment_account) { create(:payment_account, user: friend) }
  let!(:other_friend_payment_account) { create(:payment_account, user: other_friend) }
  let!(:external_payment_source_one) { create(:external_payment_source, user: user) }
  let!(:external_payment_source_two) { create(:external_payment_source, user: friend) }
  let!(:external_payment_source_three) { create(:external_payment_source, user: other_friend) }
  let!(:friendship_one) do
    create(:friendship, first_friend: user, second_friend: friend)
  end
  let!(:friendship_two) do
    create(:friendship, first_friend: user, second_friend: other_friend)
  end

  subject(:create_payment) do
    post api_v1_user_payment_path(user_id), params: params, as: :json
  end

  let(:params) do
    {
      payment: {
        friend_id: friend_id,
        amount: amount,
        description: 'thanks for lending me money'
      }
    }
  end

  describe 'when the user exists' do
    let(:user_id) { user.id }

    context 'when the friend exists' do
      let(:friend_id) { friend.id }

      context 'when the amount is positive' do
        context 'when the amount is greater than the user balance' do
          let(:amount) { 550 }

          it 'creates a new payment' do
            expect { create_payment }.to change { Payment.count }.by(1)
          end

          it 'decreases user balance to 0' do
            expect { create_payment }.to change { user_payment_account.reload.balance }.from(500)
                                                                                       .to(0)
          end

          it 'increases friend balance to 1050' do
            expect { create_payment }.to change { friend_payment_account.reload.balance }.from(500)
                                                                                         .to(1050)
          end

          it 'does not change other friend balance' do
            expect { create_payment }.not_to change { other_friend_payment_account.reload.balance }
          end

          it 'creates a payment with the expected sender' do
            create_payment
            expect(Payment.first.sender.id).to eql(user.id)
          end

          it 'creates a payment with the expected receiver' do
            create_payment
            expect(Payment.first.receiver.id).to eql(friend.id)
          end

          it 'creates a payment with the expected amount' do
            create_payment
            expect(Payment.first.amount).to eql(amount.to_f)
          end

          it 'generates a feed' do
            expect { create_payment }.to change { Feed.count }.by(1)
          end

          it 'generates a feed with the expected message' do
            create_payment
            payment = Payment.first
            expect(Feed.first.description).to eql(
              I18n.t('api.models.feeds.description', user: user.username,
                                                     friend: friend.username,
                                                     timestamp: payment.created_at,
                                                     description: payment.description)
            )
          end
        end

        context 'when the amount is less or equal than the user balance' do
          let(:amount) { 450 }

          it 'creates a new payment' do
            expect { create_payment }.to change { Payment.count }.by(1)
          end

          it 'decreases user balance to 0' do
            expect { create_payment }.to change { user_payment_account.reload.balance }.from(500)
                                                                                       .to(50)
          end

          it 'increases friend balance to 1050' do
            expect { create_payment }.to change { friend_payment_account.reload.balance }.from(500)
                                                                                         .to(950)
          end
        end
      end

      context 'when the amount is negative' do
        let(:amount) { -100 }

        it 'returns a bad request' do
          expect { create_payment }.to raise_error(Payments::NegativeAmountError)
        end
      end
    end

    context 'when the friend does not exist' do
      let(:friend_id) { 0 }
      let(:amount) { 550 }

      it 'returns a not found response' do
        create_payment
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'when the user does not exist' do
    let(:user_id) { 0 }
    let(:friend_id) { friend.id }
    let(:amount) { 550 }

    it 'returns a not found response' do
      create_payment
      expect(response).to have_http_status(:not_found)
    end
  end
end

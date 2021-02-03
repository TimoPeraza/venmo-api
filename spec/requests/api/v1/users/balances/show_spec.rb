describe 'GET api/v1/users/:id/balance', type: :request do
  let!(:user) { create(:user) }
  let!(:payment_account) { create(:payment_account, user: user) }

  subject(:get_balance) { get api_v1_user_balance_path(user_id), as: :json }

  describe 'when the user exists' do
    let(:user_id) { user.id }

    it 'returns a successful response' do
      get_balance
      expect(response).to be_successful
    end

    it 'returns the payment_account info' do
      get_balance
      expect(json[:payment_account]).to include_json(
        balance: payment_account.balance
      )
    end
  end

  describe 'when the user does not exist' do
    let(:user_id) { 0 }

    it 'returns a not found response' do
      get_balance
      expect(response).to have_http_status(:not_found)
    end
  end
end

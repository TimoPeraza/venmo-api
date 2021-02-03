describe 'GET api/v1/users/:id/feeds', type: :request do
  let!(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:friend_of_friend) { create(:user) }
  let!(:other_user) { create(:user) }

  let!(:friendship_one) { create(:friendship, first_friend: user, second_friend: friend) }
  let!(:friendship_two) do
    create(:friendship, first_friend: friend, second_friend: friend_of_friend)
  end
  let!(:friendship_three) do
    create(:friendship, first_friend: friend_of_friend, second_friend: other_user)
  end

  let!(:payment_one) { create(:payment, sender: user, receiver: friend) }
  let!(:payment_two) { create(:payment, sender: friend_of_friend, receiver: friend) }
  let!(:payment_three) { create(:payment, sender: friend_of_friend, receiver: other_user) }

  subject(:get_feeds) do
    get api_v1_user_feeds_path(user_id), params: params
  end

  let(:params) do
    {
      page: 1
    }
  end

  before do
    payment_two.feed.update!(created_at: Faker::Time.forward(days: 23, period: :morning))
  end

  describe 'when the user exists' do
    let(:user_id) { user.id }
    let(:expected_feed_list) { [payment_two.feed, payment_one.feed] }

    it 'returns a successful response' do
      get_feeds
      expect(response).to be_successful
    end

    it 'returns the feeds in the expected order' do
      get_feeds
      expect(json[:feeds][0][:id]).to eql(payment_two.feed.id)
      expect(json[:feeds][1][:id]).to eql(payment_one.feed.id)
    end

    it 'returns the feeds info' do
      get_feeds
      expect(json[:feeds]).to include_json(
        expected_feed_list.map do |feed|
          {
            id: feed.id,
            description: feed.description
          }
        end
      )
    end

    context 'when there are more than 10 feeds' do
      let!(:more_payments) { create_list(:payment, 10, sender: user, receiver: friend) }

      it 'returns only 10 feeds in the first page' do
        get_feeds
        expect(json[:feeds].count).to eql(10)
      end

      it 'returns correctly total feeds' do
        get_feeds
        expect(json[:total_count]).to eql(12)
      end

      it 'returns correctly total pages' do
        get_feeds
        expect(json[:total_pages]).to eql(2)
      end
    end
  end

  describe 'when the user does not exist' do
    let(:user_id) { 0 }

    it 'returns a not found response' do
      get_feeds
      expect(response).to have_http_status(:not_found)
    end
  end
end

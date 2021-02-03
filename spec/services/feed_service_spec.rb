describe FeedService do
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

  subject(:feed_service) do
    FeedService.new(user).list
  end

  before do
    payment_two.feed.update!(created_at: Faker::Time.forward(days: 23, period: :morning))
  end

  let(:expected_feed_list) { [payment_two.feed, payment_one.feed] }

  it 'returns the expected amount of feeds' do
    expect(feed_service.count).to eql(2)
  end

  it 'returns the expected list of feeds' do
    expect(feed_service).to eq(expected_feed_list)
  end
end

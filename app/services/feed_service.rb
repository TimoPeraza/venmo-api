class FeedService
  attr_reader :user_and_friends_ids

  def initialize(user)
    @user_and_friends_ids = user.friends_and_me_ids
  end

  def list
    FeedsQuery.new(user_and_friends_ids).feeds
  end
end

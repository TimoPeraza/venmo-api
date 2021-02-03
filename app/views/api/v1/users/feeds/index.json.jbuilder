json.feeds @feeds, partial: 'info', as: :feed
json.current_page @feeds.current_page
json.total_pages  @feeds.total_pages
json.next_page    @feeds.next_page
json.page_size    @feeds.size
json.total_count  @feeds.total_count

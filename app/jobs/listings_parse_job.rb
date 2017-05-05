class ListingsParseJob < ApplicationJob
  queue_as :default

  def perform(ids)
    ids.each do |id|
      Scrapper.full_parse(id)
    end
  end
end

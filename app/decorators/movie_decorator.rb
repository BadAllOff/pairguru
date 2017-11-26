class MovieDecorator < Draper::Decorator
  delegate_all
  # delegate :current_page, :total_pages, :limit_value, to: :source
  def cover
    "http://lorempixel.com/100/150/" +
      %w(abstract nightlife transport).sample +
      "?a=" + SecureRandom.uuid
  end
end

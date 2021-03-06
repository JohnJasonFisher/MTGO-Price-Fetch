class Card < ActiveRecord::Base
  has_many :card_users
  has_many :users, through: :card_users
  has_many :prices

  validates :multiverse_id, presence: true
  # validates :multiverse_id, :numericality => {:only_integer => true}, message: 'must be a number'

  def price
    current_price
  end

  def find_multiverse_id(card_name)
    Unirest.get("https://api.magicthegathering.io/v1/cards/#{multiverse_id}").body
  end

  def data
    @data ||= Unirest.get("https://api.magicthegathering.io/v1/cards/#{multiverse_id}").body
    @data
  end

  def show_name
    data["card"]["name"]
  end

  def show_set_name
    data["card"]["setName"]
  end

  def show_set
    data["card"]["set"]
  end

  def show_image
    data["card"]["imageUrl"]
  end

  def pull_market_price
    price = Unirest.get("http://api.mtgowikiprice.com/api/card/price?sets=#{set}&cardNames=#{name}&api_key=#{ENV['API_KEY']}").body
    p name
    p price
    price = price.split(';')[2][0..-2].to_f
    Price.create(
      price: price,
      card_id: id
    )
    price
  end

  def self.record_market_prices
    cards = Card.all
    cards.each do |card|
      card_price = card.pull_market_price
      if card_price != card.current_price
        card.current_price = card_price
        card.save
      end
    end
  end

  def growth_rate
    original_card_price = Price.order(created_at: :asc).first.price
    n = current_price - original_card_price
    d = original_card_price
    n / d
  end

  def two_decimal_growth_rate
    two_decimal_growth_rate = (growth_rate * 100).to_s[0..2].delete(".")
  end
end

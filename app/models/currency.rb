class Currency < ActiveRecord::Base
  def self.latest
    order(created_at: :desc).first
  end
end

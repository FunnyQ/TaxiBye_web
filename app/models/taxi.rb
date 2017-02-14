# == Schema Information
#
# Table name: taxis
#
#  plate_number :string           not null, primary key
#  driver       :string           default("")
#  avg_rating   :decimal(3, 1)    default(0.0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Taxi < ApplicationRecord
  self.primary_key = 'plate_number'

  has_many :trips, foreign_key: 'taxi_plate_number'
  has_many :ratings, through: :trips # TODO: need adding counter cache

  scope :ranking, -> { order(avg_rating: :desc) }

  def update_avg_rating
    all_ratings = ratings.select('score').map(&:score)
    self.avg_rating = all_ratings.sum / all_ratings.size

    save
  end
end

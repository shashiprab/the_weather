class Gridpoint < Spyke::Base
  include_root_in_json false
  self.primary_key = :grid_id

  # has_one :forecast
  # uri 'gridpoints(/:id/forecast)' # 'gridpoints/{office}/{grid X},{grid Y}/forecast'

  def periods
    properties["periods"].map do |p|
      Period.new(p)
    end
  end
end
class Coordinate < Spyke::Base
  self.connection = Faraday.new(url: 'https://api.geoapify.com') do |c|
    c.request   :json
    c.use       JSONParser
    c.adapter   Faraday.default_adapter
  end
  include_root_in_json false


  def props
    self.features.first["properties"]
  end

  def lat_comma_lon
    "#{self.props['lat'].truncate(4)},#{self.props['lon'].truncate(4)}"
  end

  def zipcode
  	self.props["postcode"]
  end
end

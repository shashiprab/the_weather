class JSONParser < Faraday::Response::Middleware
  def parse(body)
    json = MultiJson.load(body, symbolize_keys: true)
    {
      data: json,
      metadata: json[:extra],
      errors: json[:errors]
    }
  end
end

Spyke::Base.connection = Faraday.new(url: 'https://api.weather.gov') do |c|
  c.request   :json
  c.use       JSONParser
  c.adapter   Faraday.default_adapter
end
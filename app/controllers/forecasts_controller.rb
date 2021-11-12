class ForecastsController < ApplicationController

  def index
     if params[:address].present?
      encoded_addr = addr_param_encode(params[:address])
      coordinate = find_coordinate(encoded_addr)
      if coordinate.features.empty?
      	invalid_address
      else
        @zipcode = coordinate.zipcode # parsed zipcode

        @address_cached = Rails.cache.exist?(@zipcode)
        @current_period = Rails.cache.fetch(@zipcode, expires_in: 30.minutes) do
          first_period(coordinate)
        end
        if @current_period.nil?
          invalid_address
          Rails.cache.delete(@zipcode)
        end
      end
    end

    respond_to do |format|
      format.js {render layout: false}
      format.html { render 'index'}
    end
  end

  private

  def clear_notice
  	flash.notice = nil
  end

  def invalid_address
    flash.now[:notice] = "Address is invalid!"
  end

  def geocode_api_key
    "bb97855266a9446e8388a98e8f137ea6"
  end

  def addr_param_encode(address)
    URI.encode_www_form_component(address)
  end

  def find_coordinate(encoded_addr)
    data = Coordinate.request(:get, "v1/geocode/search?text=#{encoded_addr}&apiKey=#{geocode_api_key}").data
    Coordinate.new(data) # wrap data in coordinate
  end

  def find_point(coordinate)
    Point.find("#{coordinate.lat_comma_lon}") # https://api.weather.gov/points/40.7484,-73.9856
  end

  def first_period(coordinate)
    the_point = find_point(coordinate)
    return nil if the_point.respond_to?(:status) && the_point.status > 200
    Gridpoint.with(:forecast).find("#{the_point.grid}").periods.first # "gridpoints/#{office}/#{grid_x},#{grid_y}/forecast")
  end
end

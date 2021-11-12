class Point < Spyke::Base
  include_root_in_json false

  def props
    self.properties rescue binding.pry
  end

  def grid
    "#{self.props['gridId']}/#{self.props['gridX']},#{self.props['gridY']}"
  end
end
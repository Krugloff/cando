require_relative 'test_helper'

class CandoTest < Test::Unit::TestCase
  def self.startup
    Cando.authorize(Controller) { |auth| auth.for_owner :create }
      .authorize(Controller) { |auth| auth.for_client :index }
  end

  def self.shutdown
    Controller.filters.clear
  end

  test 'authorize' do
    assert_equal Controller.filters.size, 2
  end
end
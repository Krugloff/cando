require_relative 'test_helper'

class CandoTest < Test::Unit::TestCase
  def self.shutdown
    Controller.filters.clear
  end

  setup do
    @before = Controller.filters.size
  end

  test 'authorize' do
    Cando .authorize(Controller) { |auth| auth.for_owner :create }
          .authorize(Controller) { |auth| auth.for_client :index }

    assert @before < Controller.filters.size
  end

  test 'extend' do
    Controller.class_exec { extend Cando }
    Controller.class_exec { authorize { for_owner %i(edit update) } }

    assert @before < Controller.filters.size
  end
end
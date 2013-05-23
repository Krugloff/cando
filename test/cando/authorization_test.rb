require_relative '../test_helper'

class AuthorizationTest < Test::Unit::TestCase
  def self.startup
    @@auth = Cando::Authorization.new(Controller)
      .for_owner(:show)
      .for_client(:index)
      .for_admin(:index)
  end

  test 'authorization' do
    assert Controller.filters[0].call(Controller.new)
  end

  test 'no helper' do
    assert_raise Cando::Errors::NoHelper do
      Controller.filters[1].call(Controller.new)
    end
  end

  test 'access denied' do
    assert_raise Cando::Errors::AccessDenied do
      Controller.filters[2].call(Controller.new)
    end

    assert_equal Cando::Errors::AccessDenied.new(:admin).type, :admin
  end

  test 'define helper' do
    before = ApplicationController.instance_methods.size
    @@auth.for_guest :preview
    after = ApplicationController.instance_methods.size

    assert after > before

    assert Controller.new.for_owner { true }
    assert !Controller.new.for_admin { true }
  end
end
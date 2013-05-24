require_relative '../test_helper'

class AuthorizationTest < Test::Unit::TestCase
  def self.startup
    @@auth = Cando::Authorization.new(Controller)
  end

  test 'authorization' do
    @@auth.for_owner :show
    assert Controller.filters.last.call Controller.new
  end

  test 'no helper' do
    assert_raise Cando::Errors::NoHelper do
      @@auth.for_client :index
      Controller.filters.last.call Controller.new
    end
  end

  test 'access denied' do
    assert_raise Cando::Errors::AccessDenied do
      @@auth.for_admin :create
      Controller.filters.last.call Controller.new
    end

    assert_equal Cando::Errors::AccessDenied.new(:admin).type, :admin
  end

  test 'define helper' do
    before = Cando::Authorization::Helper.instance_methods.size
    @@auth.for_guest :preview
    after = Cando::Authorization::Helper.instance_methods.size

    assert after > before

    assert Controller.new.for_owner { true }
    assert !Controller.new.for_admin { true }
  end
end
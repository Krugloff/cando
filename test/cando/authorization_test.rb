require_relative '../test_helper'

class AuthorizationTest < Test::Unit::TestCase
  def self.startup
    @@auth = Cando::Authorization.new(Controller)
  end

  test 'authorization' do
    @@auth.for_owner :show
    assert Controller.filters.last.call Controller.new

    before = Controller.filters.size
    @@auth.for_hacker :all
    after = Controller.filters.size

    assert after > before
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
    before = _helpers_count
    @@auth.for_guest :preview
    after = _helpers_count

    assert after > before

    before_helpers = _helpers_count
    before_filters = Controller.filters.size
    @@auth.for_president
    after_helpers = _helpers_count
    after_filters = Controller.filters.size

    assert after_helpers > before_helpers
    assert_equal after_filters, before_filters

    assert Controller.new.for_owner { true }
    assert !Controller.new.for_admin { true }
    assert Controller.new.for_president { true }
  end

  private

    def _helpers_count
      Cando::Authorization::Helper.instance_methods.size
    end
end
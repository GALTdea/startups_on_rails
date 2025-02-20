require "test_helper"

class Admin::DashboardPolicyTest < ActiveSupport::TestCase
  def setup
    @admin = users(:admin)
    @regular_user = users(:regular_user)
  end

  def test_index
    assert Admin::DashboardPolicy.new(@admin, nil).index?
    assert_not Admin::DashboardPolicy.new(@regular_user, nil).index?
  end

  def test_show
    assert Admin::DashboardPolicy.new(@admin, nil).show?
    assert_not Admin::DashboardPolicy.new(@regular_user, nil).show?
  end

  def test_create
    assert Admin::DashboardPolicy.new(@admin, nil).create?
    assert_not Admin::DashboardPolicy.new(@regular_user, nil).create?
  end

  def test_update
    assert Admin::DashboardPolicy.new(@admin, nil).update?
    assert_not Admin::DashboardPolicy.new(@regular_user, nil).update?
  end

  def test_destroy
    assert Admin::DashboardPolicy.new(@admin, nil).destroy?
    assert_not Admin::DashboardPolicy.new(@regular_user, nil).destroy?
  end
end

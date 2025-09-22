class UserPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present? && (record.id == user.id || access_private_data?)
  end

  def new?
    create?
  end

  def create?
    access_private_data?
  end
end

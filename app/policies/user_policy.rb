class UserPolicy < ApplicationPolicy
  def show?
    user.present? && record.id == user.id
  end

  def access_private_data?
    user.present? && user.admin?
  end
end

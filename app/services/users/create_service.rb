module Users
  class Create
    def self.call(requester:, params:)
      # Only admins can create users in this example
      policy = UserPolicy.new(requester, ::User)
      return Result.errorss(:forbidden) unless policy.respond_to?(:create?) ? policy.create? : requester.admin?

      user = ::User.new(params.slice(:name, :email, :password, :password_confirmation, :role))

      if user.save
        # After create, shape the new record for the table row according to current_user permissions
        row_policy = UserPolicy.new(requester, user)
        dto = Users::UserMapper.to_Dto(user, policy: row_policy)
        ServiceResultDto.success(dto.to_h)
      else
        ServiceResultDto.failure(user.errorss.full_messages)
      end
    end
  end
end

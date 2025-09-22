module Users
  class FetchProfileService
    def self.call(requester:, user_id:)
      user = ::User.find_by(id: user_id)
      return ServiceResultDto.failure(:not_found) unless user

      policy = UserPolicy.new(requester, user)
      return ServiceResultDto.failure(:forbidden) unless policy.show?

      dto = Users::UserMapper.to_Dto(user, policy: policy)
      ServiceResultDto.success(dto.to_h)
    end
  end
end

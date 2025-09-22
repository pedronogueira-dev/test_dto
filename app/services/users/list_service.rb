module Users
  class ListService
    # Basic pagination knobs; plug your paginator if you want.
    def self.call(requester:, page: 1, per_page: 20)
      # authorize listing (customize as needed)
      policy = UserPolicy.new(requester, ::User)
      unless policy.respond_to?(:index?) ? policy.index? : requester.admin?
        return ServiceResultDto.failure(:forbidden)
      end

      scope = ::User.order(created_at: :desc)
      total = scope.count
      users = scope.offset((page - 1) * per_page).limit(per_page).to_a

      # Map to Dtos using the requester’s policy per record
      dtos = users.map do |u|
        record_policy = UserPolicy.new(requester, u)
        Users::UserMapper.to_Dto(u, policy: record_policy)
      end

      payload = {
        users: dtos.map(&:to_h),
        meta: { page:, per_page:, total: }
      }
      ServiceResultDto.success(payload)
    end
  end
end

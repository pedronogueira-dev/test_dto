module Users
  class UserMapper
    def self.to_Dto(user, policy:)
      if policy.access_private_data?
        Users::AdminShowDto.new(
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email_address: user.email_address,
          age: user.age,
          birth_date: user.birth_date,
          access_token: user.password_digest
        )
      else
        Users::ShowDto.new(
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email_address: user.email_address
        )
      end
    end
  end
end

ServiceResultDTO = Data.define(:success, :data, :errors) do
  def self.success(data)
    new(success: true, data: data, errors: nil)
  end

  def self.failure(errors)
    new(success: false, data: nil, errors: errors)
  end
end

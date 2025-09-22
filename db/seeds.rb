# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.find_or_create_by!(email_address: "test1@example.com") do |user|
  user.first_name = "Test"
  user.last_name = "User"
  user.birth_date = "1991-01-01"
  user.password_digest = BCrypt::Password.create("test")
  user.admin = true
end

User.find_or_create_by!(email_address: "test2@example.com") do |user|
  user.first_name = "A"
  user.last_name = "B"
  user.birth_date = "1997-08-01"
  user.password_digest = BCrypt::Password.create("1234")
end


Project.find_or_create_by!(name: "Project 1") do |project|
  project.access_token = "project1_access_token_#{SecureRandom.uuid}"
  project.last_version = 1.0
end
Project.find_or_create_by!(name: "ASXA") do |project|
  project.access_token = "asdasda_#{SecureRandom.uuid}"
  project.last_version = 3.12
end
Project.find_or_create_by!(name: "asdas") do |project|
  project.access_token = "1231w_#{SecureRandom.uuid}"
  project.last_version = 0.1
end

UserProject.find_or_create_by!(user: User.first, project: Project.first)
UserProject.find_or_create_by!(user: User.first, project: Project.second)
UserProject.find_or_create_by!(user: User.second, project: Project.third)
UserProject.find_or_create_by!(user: User.second, project: Project.first)

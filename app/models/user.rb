class User < ApplicationRecord
    has_secure_password
  
    # Validation for name
    validates :name, presence: true
  
    # Validation for email
    validates :email, presence: true, uniqueness: { message: "is already in use." },  format: { with: URI::MailTo::EMAIL_REGEXP}
  
    # Validation for password
    validates :password, presence: true, if: -> {password_confirmation.present?} # length: { minimum: 1} Use to change length if needed
    validates :password_confirmation, presence: true, if: -> { password.present? }

    # Validation for status
    validates :status, inclusion: { in: [true, false] }
  end
  
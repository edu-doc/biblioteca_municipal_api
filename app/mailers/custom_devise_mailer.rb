class CustomDeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    @edit_password_url = "http://localhost:8080/resetar-senha?reset_password_token=#{token}"
    super
  end
end
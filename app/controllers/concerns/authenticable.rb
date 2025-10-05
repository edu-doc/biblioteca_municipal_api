# frozen_string_literal: true

module Authenticable
  def current_bibliotecario
    @current_bibliotecario ||= Bibliotecario.find_by(token: request.headers['Authorization'])
  end

  def user_signed_in?
    current_bibliotecario.present?
  end

  def authenticate_with_token
    render json: { errors: 'Not authenticated' }, status: :unauthorized unless user_signed_in?
  end
end

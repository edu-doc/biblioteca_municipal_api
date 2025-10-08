# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authenticable

  before_action :forcar_troca_de_senha

  rescue_from SecurityError, with: :deny_access_admin

  private

  def authorize_admin!
    unless user_signed_in? && current_bibliotecario.admin?
      raise SecurityError, 'Acesso negado. Apenas administradores podem realizar esta ação.'
    end
  end

  def deny_access_admin
    render json: { errors: 'Acesso negado. Apenas administradores podem realizar esta ação.' }, status: :forbidden
  end

  def forcar_troca_de_senha
    return unless user_signed_in? && current_bibliotecario.primeiro_acesso?
    return if request.path == api_v1_bibliotecario_path(current_bibliotecario) && request.put?

    render json: {
      errors: 'Acesso negado. Você precisa alterar sua senha provisória antes de continuar.'
    }, status: :forbidden
  end
end

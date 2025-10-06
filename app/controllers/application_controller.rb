# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authenticable

  before_action :forcar_troca_de_senha

  private

  def forcar_troca_de_senha
    return unless user_signed_in? && current_bibliotecario.primeiro_acesso?
    return if request.path == api_v1_bibliotecario_path(current_bibliotecario) && request.put?

    render json: {
      errors: 'Acesso negado. Você precisa alterar sua senha provisória antes de continuar.'
    }, status: :forbidden
  end
end

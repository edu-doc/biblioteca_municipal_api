# frozen_string_literal: true

module Bibliotecarios
  class PasswordsController < ApplicationController
    skip_before_action :authenticate_with_token, only: %i[create update], raise: false
    skip_before_action :forcar_troca_de_senha, only: %i[create update], raise: false

    # POST /api/v1/bibliotecarios/password
    def create
      bibliotecario = Bibliotecario.find_by(email: params.dig(:bibliotecario, :email))
      if bibliotecario
        bibliotecario.send_reset_password_instructions
        render json: { message: 'Instruções de recuperação enviadas para o seu e-mail.' }, status: :ok
      else
        render json: { errors: ['Email não encontrado ou inválido.'] }, status: :not_found
      end
    end

    # PUT /api/v1/bibliotecarios/password
    def update
      resource = Bibliotecario.reset_password_by_token(update_params)

      if resource.errors.empty?
        render json: { message: 'Sua senha foi alterada com sucesso.' }, status: :ok
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    # Parâmetros permitidos para o update
    def update_params
      params.require(:bibliotecario).permit(:password, :password_confirmation, :reset_password_token)
    end
  end
end
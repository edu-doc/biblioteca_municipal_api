# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        bibliotecario_password = params[:session][:password]
        bibliotecario_email = params[:session][:email]
        bibliotecario = bibliotecario_email.present? && Bibliotecario.find_by(email: bibliotecario_email)

        return render json: { errors: 'E-mail ou senha inválidos' }, status: :unauthorized unless bibliotecario

        if bibliotecario.primeiro_acesso?
          if ActiveSupport::SecurityUtils.secure_compare(bibliotecario.senha_provisoria, bibliotecario_password)
            sign_in_and_generate_token(bibliotecario)
          else
            render json: { errors: 'E-mail ou senha provisória inválidos' }, status: :unauthorized
          end
        elsif bibliotecario.valid_password?(bibliotecario_password)
          sign_in_and_generate_token(bibliotecario)
        else
          render json: { errors: 'E-mail ou senha inválidos' }, status: :unauthorized
        end
      end

      def destroy
        bibliotecario = Bibliotecario.find_by(token: params[:token])
        if bibliotecario
          bibliotecario.gerador_token_autenticacao
          bibliotecario.save
          head :no_content
        else
          render json: { errors: 'Token inválido ou não encontrado' }, status: :not_found
        end
      end

      private

      def sign_in_and_generate_token(bibliotecario)
        sign_in bibliotecario, store: false
        bibliotecario.gerador_token_autenticacao
        bibliotecario.save

        render json: {
          token: bibliotecario.token,
          primeiro_acesso: bibliotecario.primeiro_acesso?
        }, status: :ok
      end
    end
  end
end

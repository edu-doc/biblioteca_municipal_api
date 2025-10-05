# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        bibliotecario_passoword = params[:session][:password]
        bibliotecario_email = params[:session][:email]

        bibliotecario = bibliotecario_email.present? && Bibliotecario.find_by(email: bibliotecario_email)

        if bibliotecario.valid_password?(bibliotecario_passoword)
          sign_in bibliotecario, store: false
          bibliotecario.gerador_token_autenticacao
          bibliotecario.save
          render json: { token: bibliotecario.token }, status: 200
        else
          render json: { errors: 'Invalid email or password' }, status: 401
        end
      end

      def destroy
        bibliotecario = Bibliotecario.find_by(token: params[:token])
        if bibliotecario
          bibliotecario.gerador_token_autenticacao
          bibliotecario.save
          head 204
        else
          render json: { errors: 'Token inválido ou não encontrado' }, status: 404
        end
      end
    end
  end
end

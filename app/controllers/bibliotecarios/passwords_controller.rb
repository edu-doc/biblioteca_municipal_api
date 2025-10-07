# frozen_string_literal: true

module Bibliotecarios
  module Bibliotecarios
    class PasswordsController < Devise::PasswordsController
      skip_before_action :authenticate_with_token, only: %i[create update]
      respond_to :json

      def create
        self.resource = resource_class.send_reset_password_instructions(resource_params)
        yield resource if block_given?

        if successfully_sent?(resource)
          render json: { message: 'Instruções de recuperação enviadas para o seu e-mail.' }, status: :ok
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        self.resource = resource_class.reset_password_by_token(resource_params)
        yield resource if block_given?

        if resource.errors.empty?
          resource.unlock_access! if unlockable?(resource)
          render json: { message: 'Sua senha foi alterada com sucesso.' }, status: :ok
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end

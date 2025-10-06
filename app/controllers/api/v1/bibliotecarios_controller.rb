# frozen_string_literal: true

module Api
  module V1
    class BibliotecariosController < ApplicationController
      respond_to :json

      def show
        bibliotecario = Bibliotecario.find(params[:id])
        render json: bibliotecario, only: %i[id nome email senha_provisoria created_at updated_at], status: 200
      end

      def create
        bibliotecario = Bibliotecario.new(bibliotecario_params)
        if bibliotecario.save
          render json: bibliotecario, status: 201, location: [:api, :v1, bibliotecario]
        else
          render json: { errors: bibliotecario.errors }, status: 422
        end
      end

      def update
        bibliotecario = Bibliotecario.find(params[:id])

        params_to_use = bibliotecario.primeiro_acesso? ? first_login_params : bibliotecario_params

        if bibliotecario.primeiro_acesso? && params_to_use[:password].present?
          params_to_use[:primeiro_acesso] = false
          params_to_use[:senha_provisoria] = nil
        end

        if bibliotecario.update(params_to_use)
          render json: bibliotecario, status: :ok, location: [:api, :v1, bibliotecario]
        else
          render json: { errors: bibliotecario.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        bibliotecario = Bibliotecario.find(params[:id])
        bibliotecario.destroy
        head 204
      end

      private

      def bibliotecario_params
        params.require(:bibliotecario).permit(:email, :nome, :senha_provisoria)
      end

      def first_login_params
        params.require(:bibliotecario).permit(:password)
      end
    end
  end
end

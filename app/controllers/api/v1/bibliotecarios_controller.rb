# frozen_string_literal: true

module Api
  module V1
    class BibliotecariosController < ApplicationController
      respond_to :json

      def show
        @bibliotecario = Bibliotecario.find(params[:id])
        render json: @bibliotecario, only: [:nome, :email]
      end

      def create
        bibliotecario = Bibliotecario.new(bibliotecario_params)
        if bibliotecario.save
          render json: bibliotecario, status: 201, location: [:api, :v1, bibliotecario]
        else
          render json: { errors: bibliotecario.errors }, status: 422
        end
      end

      private

      def bibliotecario_params
        params.require(:bibliotecario).permit(:email, :password, :password_confirmation, :nome, :senha_provisoria)
      end
    end
  end
end

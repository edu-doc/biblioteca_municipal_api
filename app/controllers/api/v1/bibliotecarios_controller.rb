# frozen_string_literal: true

module Api
  module V1
    class BibliotecariosController < ApplicationController
      respond_to :json

      def show
        bibliotecario = Bibliotecario.find(params[:id])
        render json: bibliotecario, only: %i[nome email senha_provisoria]
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
        if bibliotecario.update(bibliotecario_params)
          render json: bibliotecario, status: 200, location: [:api, :v1, bibliotecario]
        else
          render json: { errors: bibliotecario.errors }, status: 422
        end
      end

      def destroy
        bibliotecario = Bibliotecario.find(params[:id])
        bibliotecario.destroy
        head 204
      end

      private

      def bibliotecario_params
        params.require(:bibliotecario).permit(:email, :password, :nome)
      end
    end
  end
end

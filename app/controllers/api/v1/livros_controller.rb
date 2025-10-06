# frozen_string_literal: true

module Api
  module V1
    class LivrosController < ApplicationController
      def index
        livros = Livro.all
        render json: livros, only: %i[titulo autor status observacoes categoria_id], status: 200
      end

      def show
        livro = Livro.find(params[:id])
        render json: livro, only: %i[titulo autor status observacoes categoria_id], status: 200
      end

      def create
        livro = Livro.new(livro_params)
        if livro.save
          render json: livro, status: 201
        else
          render json: { errors: livro.errors }, status: 422
        end
      end

      def update
        livro = Livro.find(params[:id])
        if livro.update(livro_params)
          render json: livro, status: 200
        else
          render json: { errors: livro.errors }, status: 422
        end
      end

      def destroy
        livro = Livro.find(params[:id])
        livro.destroy
        head 204
      end

      private

      def livro_params
        params.require(:livro).permit(:titulo, :autor, :status, :observacoes, :categoria_id)
      end
    end
  end
end

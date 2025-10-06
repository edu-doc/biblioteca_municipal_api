# frozen_string_literal: true

module Api
    module V1
        class CategoriasController < ApplicationController

            def index
                categorias = Categoria.all
                render json: categorias, only: %i[nome], status: 200
            end

            def show
                categoria = Categoria.find(params[:id])
                render json: categoria, only: %i[nome], status: 200
            end

            def create
                categoria = Categoria.new(categoria_params)
                if categoria.save
                render json: categoria, status: 201
                else
                render json: { errors: categoria.errors }, status: 422
                end
            end

            def update
                categoria = Categoria.find(params[:id])
                if categoria.update(categoria_params)
                render json: categoria, status: 200
                else
                render json: { errors: categoria.errors }, status: 422
                end
            end

            def destroy
                categoria = Categoria.find(params[:id])
                categoria.destroy
                head 204
            end

            private
      
            def categoria_params
                params.require(:categoria).permit(:nome)
            end

        end
    end
end


# frozen_string_literal: true

module Api
  module V1
    class EmprestimosController < ApplicationController
      def index
        emprestimos = Emprestimo.all
        render json: emprestimos,
               only: %i[id livro_id usuario_id bibliotecario_id data_emprestimo data_limite_devolucao data_devolucao created_at updated_at], status: 200
      end

      def show
        emprestimo = Emprestimo.find(params[:id])
        render json: emprestimo,
               only: %i[livro_id usuario_id bibliotecario_id data_emprestimo data_limite_devolucao data_devolucao created_at updated_at], status: 200
      end

      def create
        emprestimo = Emprestimo.new(emprestimo_params)
        if emprestimo.save
          render json: emprestimo, status: 201
        else
          render json: { errors: emprestimo.errors }, status: 422
        end
      end

      def update
        emprestimo = Emprestimo.find(params[:id])
        if emprestimo.update(emprestimo_params)
          render json: emprestimo, status: 200
        else
          render json: { errors: emprestimo.errors }, status: 422
        end
      end

      def destroy
        emprestimo = Emprestimo.find(params[:id])
        emprestimo.destroy
        head 204
      end

      private

      def emprestimo_params
        params.require(:emprestimo).permit(:livro_id, :usuario_id, :bibliotecario_id, :data_emprestimo,
                                           :data_limite_devolucao, :data_devolucao)
      end
    end
  end
end

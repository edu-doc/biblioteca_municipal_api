# frozen_string_literal: true

module Api
  module V1
    class UsuariosController < ApplicationController

      before_action :authenticate_with_token, only: %i[create update destroy find_by_cpf]

      def index
        usuarios = Usuario.all.order(created_at: :desc)
        render json: usuarios, only: %i[id nome cpf telefone email], status: 200
      end

      def show
        usuario = Usuario.find(params[:id])
        render json: usuario, only: %i[nome cpf telefone email senha created_at updated_at], status: 200
      end

      def find_by_cpf
        cpf = params[:cpf]
        usuario = Usuario.find_by(cpf: cpf)
        if usuario
          render json: usuario, only: %i[id nome email cpf], status: :ok
        else
          render json: { errors: 'Utilizador não encontrado com o CPF fornecido.' }, status: :not_found
        end
      end

      def emprestimos_ativos
        usuario = Usuario.find_by(cpf: params[:cpf])

        unless usuario && usuario.senha == params[:senha]
          return render json: { errors: 'CPF ou Senha de Empréstimo inválidos.' }, status: :unauthorized
        end

        emprestimos = usuario.emprestimos.includes(:livro).where(data_devolucao: nil).order(data_limite_devolucao: :asc)
        render json: emprestimos, include: :livro, status: :ok
      end

      def create
        usuario = Usuario.new(usuario_params)
        if usuario.save
          render json: usuario, status: 201
        else
          render json: { errors: usuario.errors }, status: 422
        end
      end

      def update
        usuario = Usuario.find(params[:id])
        if usuario.update(usuario_params)
          render json: usuario, status: 200
        else
          render json: { errors: usuario.errors }, status: 422
        end
      end

      def destroy
        usuario = Usuario.find(params[:id])
        usuario.destroy
        head 204
      end

      # GET /api/v1/usuarios/:id/emprestimos
      def emprestimos
        usuario = Usuario.find(params[:id])
        emprestimos = usuario.emprestimos.all.order(data_emprestimo: :desc)
        render json: emprestimos, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Usuário não encontrado' }, status: 404
      end

      private

      def usuario_params
        params.require(:usuario).permit(:nome, :cpf, :telefone, :email, :senha)
      end
    end
  end
end

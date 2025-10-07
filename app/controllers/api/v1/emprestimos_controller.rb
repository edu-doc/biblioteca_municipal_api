# frozen_string_literal: true

module Api
  module V1
    class EmprestimosController < ApplicationController
      before_action :authenticate_with_token, only: %i[create update]

      def index
        @emprestimos = ::Emprestimo.all
        render json: @emprestimos, status: 200
      end

      def show
        emprestimo = Emprestimo.find(params[:id])
        render json: emprestimo,
               only: %i[livro_id usuario_id bibliotecario_id data_emprestimo data_limite_devolucao data_devolucao created_at updated_at], status: 200
      end

      def create
        begin
          livro = ::Livro.find(params[:emprestimo][:livro_id])
          usuario = ::Usuario.find(params[:emprestimo][:usuario_id])
        rescue ActiveRecord::RecordNotFound
          render json: { errors: 'Livro ou Usuário não encontrado' }, status: 404
          return
        end

        unless livro.disponivel?
          return render json: { errors: 'Livro não está disponível para empréstimo' }, status: 422
        end

        unless usuario.senha == params[:emprestimo][:senha]
          return render json: { errors: 'Senha de empréstimo inválida' }, status: 401
        end

        ::ActiveRecord::Base.transaction do
          data_emprestimo = Time.current

          data_limite = ::Emprestimo.data_limite_inicial(data_emprestimo)

          @emprestimo = ::Emprestimo.new(
            livro: livro,
            usuario: usuario,
            bibliotecario: current_bibliotecario,
            data_emprestimo: data_emprestimo,
            data_limite_devolucao: data_limite
          )

          if @emprestimo.save
            livro.emprestado!
            render json: @emprestimo, status: :created
          else
            render json: { errors: @emprestimo.errors }, status: 422
            raise ActiveRecord::Rollback
          end
        end
      end

      def update
        emprestimo = ::Emprestimo.find(params[:id])

        begin
          emprestimo.registrar_devolucao!
          render json: emprestimo, status: 200
        rescue ActiveRecord::RecordInvalid => e
          render json: { errors: e.record.errors }, status: 422
        end
      end

      # POST /api/v1/emprestimos/renovar
      def renovar
        livro_id = params[:emprestimo][:livro_id]
        senha = params[:emprestimo][:senha]

        emprestimo = ::Emprestimo.find_by(livro_id: livro_id, data_devolucao: nil)

        unless emprestimo
          return render json: { errors: 'Empréstimo ativo para este livro não encontrado.' }, status: 404
        end

        usuario = emprestimo.usuario

        unless usuario.senha == senha
          return render json: { errors: 'Senha de empréstimo inválida.' }, status: 401
        end

        if emprestimo.renovar!
          render json: emprestimo, status: :ok
        else
          render json: { errors: emprestimo.errors.full_messages }, status: 422
        end
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Livro não encontrado.' }, status: 404
      rescue ActionController::ParameterMissing
         render json: { errors: 'Parâmetros livro_id e senha são obrigatórios.' }, status: 400
      end

      def destroy
        emprestimo = Emprestimo.find(params[:id])
        emprestimo.destroy
        head 204
      end

      # GET /api/v1/emprestimos/atrasados
      def atrasados
        emprestimos_atrasados = ::Emprestimo.where('data_limite_devolucao < ? AND data_devolucao IS NULL', Time.current)
        
        render json: emprestimos_atrasados, status: 200
      end

      private

      def emprestimo_params
        params.require(:emprestimo).permit(:livro_id, :usuario_id, :senha)
      end
    end
  end
end

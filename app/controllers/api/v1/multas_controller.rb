# frozen_string_literal: true

module Api
  module V1
    class MultasController < ApplicationController
      before_action :authenticate_with_token

      def index
        @multas = ::Multum.includes(emprestimo: [:usuario, :livro]).order(created_at: :desc)
        render json: @multas, include: { emprestimo: { include: [:usuario, :livro] } }, status: :ok
      end

      def show
        @multa = ::Multum.find(params[:id])
        render json: @multa, status: :ok
      end

      def update
        @multa = ::Multum.find(params[:id])

        params[:multa][:data_pagamento] = Time.current if params[:multa][:status] == 'pago'

        if @multa.update(multa_params)
          render json: @multa, status: :ok
        else
          render json: { errors: @multa.errors }, status: :unprocessable_entity
        end
      end

      private

      def multa_params
        params.require(:multa).permit(:status, :data_pagamento)
      end
    end
  end
end

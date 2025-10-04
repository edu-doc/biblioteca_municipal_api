# frozen_string_literal: true

module Api
  module V1
    class BibliotecariosController < ApplicationController
      respond_to :json

      def show
        respond_with Bibliotecario.find(params[:id])
      end
    end
  end
end

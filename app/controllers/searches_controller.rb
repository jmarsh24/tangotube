# frozen_string_literal: true

class SearchesController < ApplicationController
  def new
  end

  def show
    search = Search.new(term: params[:search]) if params[:search].present?
    ui.replace "search-results", with: "searches/results", search:
  end
end

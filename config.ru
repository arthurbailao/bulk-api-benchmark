require 'grape'

module Bulk
  class API < Grape::API
    params do
      requires :data, type: Array[Hash]
    end
    post :load do
      indices = params[:data].map { |d| d[:index] }
      { indices: indices }
    end
  end
end

run Bulk::API

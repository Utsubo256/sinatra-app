# frozen_string_literal: true

require 'sinatra'

get '/memos' do
  json = JSON.parse(File.read('./data/memos.json'), symbolize_names: true)
  @memos = json[:memos]
  erb :'books/index'
end

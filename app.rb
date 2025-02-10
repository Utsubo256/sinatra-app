# frozen_string_literal: true

require 'sinatra'

get '/memos' do
  json = JSON.parse(File.read('./data/memos.json'), symbolize_names: true)
  @memos = json[:memos]
  erb :'books/index'
end

get '/memos/:memo_id' do
  json = JSON.parse(File.read('./data/memos.json'), symbolize_names: true)
  @memo = json[:memos].find { |memo| memo[:id] == params[:memo_id].to_i }
  erb :'books/show'
end

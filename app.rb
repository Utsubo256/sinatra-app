# frozen_string_literal: true

require 'sinatra'

def sanitize(text)
  Rack::Utils.escape_html(text)
end

get '/memos' do
  json = JSON.parse(File.read('./data/memos.json'), symbolize_names: true)
  @memos = json[:memos]
  erb :'books/index'
end

get '/memos/new' do
  erb :'books/new'
end

get '/memos/:memo_id' do
  json = JSON.parse(File.read('./data/memos.json'), symbolize_names: true)
  @memo = json[:memos].find { |memo| memo[:id] == params[:memo_id].to_i }
  erb :'books/show'
end

post '/memos' do
  json = JSON.parse(File.read('./data/memos.json'), symbolize_names: true)
  adding_memo = { id: json[:id_counter] + 1, title: sanitize(params[:title]), description: sanitize(params[:description]) }
  result_json = { id_counter: json[:id_counter] + 1, memos: [*json[:memos], adding_memo] }
  File.write('./data/memos.json', JSON.dump(result_json))
  redirect "/memos/#{adding_memo[:id]}"
end

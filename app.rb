# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative 'models'

get '/' do
  redirect '/memos'
end

get '/memos' do
  @title = 'memos'
  @memos = parse_all_data
  erb :index
end

get '/memos/new' do
  @title = 'new'
  erb :new
end

post '/memos' do
  add_new_memo(params)
  redirect '/memos'
end

get '/memos/:id/edit' do
  @title = 'edit'
  found_data = find_memo_data(params[:id].to_i)
  @id = found_data[:id]
  @name = found_data[:name]
  @text = found_data[:text]
  erb :edit
end

get '/memos/:id' do
  found_data = find_memo_data(params[:id].to_i)
  @title = 'detail'
  @id = found_data[:id]
  @name = found_data[:name]
  @text = found_data[:text]
  erb :detail
end

delete '/memos/:id' do
  delete_memo_data(params[:id].to_i)
  redirect '/memos'
end

patch '/memos/:id' do
  edit_memo_data(params)
  redirect '/memos'
end

not_found do
  'This is nowhere to be found.'
end

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
  add_new_memo(name: params[:name], text: params[:text])
  redirect '/memos'
end

get '/memos/:id/edit' do
  @title = 'edit'
  @id = params[:id].to_i
  find_memo_data
  erb :edit
end

get '/memos/:id' do
  @title = 'detail'
  @id = params[:id].to_i
  find_memo_data
  erb :detail
end

delete '/memos/:id' do
  @id = params[:id].to_i
  delete_memo_data
  redirect '/memos'
end

patch '/memos/:id' do
  @name = params[:name]
  @text = params[:text]
  @id = params[:id].to_i
  edit_memo_data
  redirect '/memos'
end

not_found do
  'This is nowhere to be found.'
end

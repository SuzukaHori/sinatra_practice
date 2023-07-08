# frozen_string_literal: true

require 'json'
require 'cgi'

def parse_json_data
  original_data = File.read('db.json')
  JSON.parse(original_data, symbolize_names: true)
end

def any_data?
  data = parse_json_data
  !data[:memos].empty?
end

def parse_all_data
  if any_data?
    data = parse_json_data
    data[:memos]
  else
    []
  end
end

def find_memo_data
  data = parse_json_data
  found_data = data[:memos].find { |memo| memo[:id] == @id }
  @name = found_data[:name]
  @text = found_data[:text]
end

def delete_memo_data
  old_data = parse_json_data
  new_data = { 'memos' => old_data[:memos].reject { |memo| memo[:id] == @id } }
  File.open('db.json', 'w') do |file|
    file.write(JSON.pretty_generate(new_data))
  end
end

def edit_memo_data
  data = parse_json_data
  data[:memos].map do |memo|
    if memo[:id] == @id
      memo[:text] = CGI.escapeHTML(@text)
      memo[:name] = CGI.escapeHTML(@name)
    end
  end

  File.open('db.json', 'w') { |file| file.write(JSON.pretty_generate(data)) }
end

class Memo
  attr_accessor :name, :text, :id

  def initialize(name:, text:)
    @name = CGI.escapeHTML(name)
    @text = CGI.escapeHTML(text)
    @id = set_id
  end
  name = '<h1>suzuka'
  text = 'text'
  @name = CGI.escapeHTML(name)
  @text = CGI.escapeHTML(text)

  def set_id
    if any_data?
      data = parse_json_data
      last_id = data[:memos][-1][:id]
    else
      last_id = 0
    end
    last_id + 1
  end

  def save_new_memo
    json_data =
      (any_data? ? JSON.parse(File.read('db.json')) : { 'memos' => [] })
    json_data['memos'].push({ 'name' => @name, 'text' => @text, 'id' => @id })
    File.open('db.json', 'w') do |file|
      file.puts(JSON.pretty_generate(json_data))
    end
  end
end

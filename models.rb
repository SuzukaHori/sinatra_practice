# frozen_string_literal: true

require 'json'
require 'cgi'

def parse_all_data
  original_data = File.read('db.json')
  data = JSON.parse(original_data, symbolize_names: true)
  data[:memos] || []
end

def find_memo_data(id)
  all_data = parse_all_data
  all_data.find { |memo| memo[:id] == id }
end

def delete_memo_data(id)
  old_data = parse_all_data
  new_data = { 'memos' => old_data.reject { |memo| memo[:id] == id } }
  File.open('db.json', 'w') do |file|
    file.write(JSON.pretty_generate(new_data))
  end
end

def edit_memo_data(params)
  symbolized_params = params.transform_keys(&:to_sym)
  all_data = parse_all_data
  all_data.each do |memo|
    if memo[:id] == id.to_i
      memo[:name] = symbolize_params[:name]
      memo[:text] = symbolize_params[:text]
    end
  end
  new_data = { memos: all_data }
  File.open('db.json', 'w') { |file| file.write(JSON.pretty_generate(new_data)) }
end

def set_id
  all_data = parse_all_all_data
  last_id = if all_data.empty?
              0
            else
              all_data[-1][:id]
            end
  last_id + 1
end

def add_new_memo(params)
  symbolized_params = params.transform_keys(&:to_sym)
  id = set_id
  all_data = parse_all_data
  all_data.push({ name: symbolized_params[:name], text: symbolized_params[:text], id: })
  new_data = { memos: all_data }
  File.open('db.json', 'w') do |file|
    file.puts(JSON.pretty_generate(new_data))
  end
end

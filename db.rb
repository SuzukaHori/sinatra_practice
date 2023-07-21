# frozen_string_literal: true

require 'json'
require 'pg'

DBNAME = 'memosdata'

def connect_database
  PG.connect(dbname: DBNAME)
end

def execute_sql(params, sql)
  name = params[:name] || nil
  text = params[:text] || nil
  id = params[:id]
  values_to_bind = [name, text, id].compact
  connection = connect_database
  connection.exec_params(sql, values_to_bind)
end

def read_all_memos
  connection = connect_database
  all_memos = connection.exec('SELECT * FROM memos;')
  all_memos.map do |memo|
    memo.store('id', memo['id'].to_i)
    memo.transform_keys(&:to_sym)
  end
end

def find_memo(id)
  memos = read_all_memos
  memos.find { |memo| memo[:id] == id }
end

def delete_memo(id)
  sql = <<~SQL
    DELETE FROM memos
    WHERE id = $1;
  SQL
  params = { id: }
  execute_sql(params, sql)
end

def edit_memo(params)
  sql = <<~SQL
    UPDATE memos
    SET name = $1::VARCHAR, text = $2::VARCHAR
    WHERE id =  $3::int;
  SQL
  symbolized_params = params.transform_keys(&:to_sym)
  execute_sql(symbolized_params, sql)
end

def add_memo(params)
  sql = <<~SQL
    INSERT INTO memos(name, text)
    VALUES ($1::VARCHAR, $2::VARCHAR);
  SQL
  symbolized_params = params.transform_keys(&:to_sym)
  execute_sql(symbolized_params, sql)
end

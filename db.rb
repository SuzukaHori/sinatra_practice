# frozen_string_literal: true

require 'json'
require 'pg'

DB_NAME = 'memosdata'

def connect_database
  PG.connect(dbname: DB_NAME)
end

def read_all_memos
  connection = connect_database
  sql = <<~SQL
    SELECT *
    FROM memos 
    ORDER BY id;
  SQL
  all_memos = connection.exec(sql)
  connection.close
  all_memos.map do |memo|
    memo.store('id', memo['id'].to_i)
    memo.transform_keys(&:to_sym)
  end
end

def find_memo(id)
  connection = connect_database
  memos = connection.exec_params('SELECT * FROM memos WHERE id = $1;', [id])
  connection.close
  memos[0].transform_keys(&:to_sym)
end

def delete_memo(id)
  sql = <<~SQL
    DELETE FROM memos
    WHERE id = $1;
  SQL
  connection = connect_database
  connection.exec_params(sql, [id])
  connection.close
end

def edit_memo(params)
  sql = <<~SQL
    UPDATE memos
    SET name = $1::VARCHAR, text = $2::VARCHAR
    WHERE id =  $3::int;
  SQL
  symbolized_params = params.transform_keys(&:to_sym)
  connection = connect_database
  connection.exec_params(sql, [params[:name], params[:text], params[:id]])
  connection.close
end

def add_memo(params)
  sql = <<~SQL
    INSERT INTO memos(name, text)
    VALUES ($1::VARCHAR, $2::VARCHAR);
  SQL
  symbolized_params = params.transform_keys(&:to_sym)
  connection = connect_database
  connection.exec_params(sql, [params[:name], params[:text]])
  connection.close
end

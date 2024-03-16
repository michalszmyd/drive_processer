class DeleteQuery
  getter table_name : String
  getter record_id : Int64

  def initialize(@table_name, @record_id)
  end

  def commit
    sql = "DELETE FROM #{table_name} WHERE id = $1"
    Logger.log("Executing update: #{sql} with #{record_id}")

    AppDatabase.exec(sql, args: [record_id])
  end
end

require "./operation_query"

class InsertQuery < OperationQuery
  def commit
    args = [] of SetAttributeValue
    columns = [] of String

    insert_attributes_sql = @set_attributes.map_with_index do |set_attribute, index|
      columns.push(set_attribute.column)

      if set_attribute.is_a?(SetJSONBValue)
        args.push("#{set_attribute.value.to_json}")
        "jsonb_set(#{set_attribute.column}, '{#{set_attribute.name}}', $#{index + 1})"
      else
        args.push(set_attribute.value)
        "$#{index + 1}"
      end
    end.join(", ")

    sql = "INSERT INTO #{table_name} (#{columns.join(", ")}) VALUES(#{insert_attributes_sql})"

    Logger.log("Executing insert: #{sql} with #{args}")

    AppDatabase.exec(sql, args: args)
  end
end

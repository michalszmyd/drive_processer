class UpdateQuery < OperationQuery
  getter record_id : Int64

  def initialize(@table_name, @record_id)
  end

  def commit
    args = [] of SetAttributeValue

    update_attributes_sql = @set_attributes.map_with_index do |set_attribute, index|
      if set_attribute.is_a?(SetJSONBValue)
        args.push("#{set_attribute.value.to_json}")
        "#{set_attribute.column} = jsonb_set(#{set_attribute.column}, '{#{set_attribute.name}}', $#{index + 1})"
      else
        args.push(set_attribute.value)
        "#{set_attribute.column} = $#{index + 1}"
      end
    end.join(", ")

    sql = "UPDATE #{table_name} SET #{update_attributes_sql} WHERE id = $#{args.size + 1}"
    sql_args = args.concat([record_id])

    Logger.log("Executing update: #{sql} with #{args}")

    AppDatabase.exec(sql, args: sql_args)
  end
end

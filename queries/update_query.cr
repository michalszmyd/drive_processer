class UpdateQuery
  alias SetAttributeValue = Int32 | String | Nil | Int64 | Time

  struct SetAttribute
    property column : String
    property value : SetAttributeValue

    def initialize(@column, @value)
    end
  end

  @set_attributes = [] of SetAttribute

  getter table_name : String
  getter record_id : Int64

  def initialize(@table_name, @record_id)
  end

  def set(column : String, value : SetAttributeValue)
    @set_attributes.push(SetAttribute.new(column: column, value: value))

    self
  end

  def commit
    args = [] of SetAttributeValue

    update_attributes_sql = @set_attributes.map_with_index do |set_attribute, index|
      args.push(set_attribute.value)
      "#{set_attribute.column} = $#{index + 1}"
    end.join(", ")

    sql = "UPDATE #{table_name} SET #{update_attributes_sql} WHERE id = $#{args.size + 1}"
    sql_args = args.concat([record_id])

    Logger.log("Executing update: #{sql} with #{args}")

    AppDatabase.exec(sql, args: sql_args)
  end
end

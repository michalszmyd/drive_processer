class OperationQuery
  alias JsonB = String

  alias SetAttributeValue = Int32 | String | Nil | Int64 | Time

  struct SetAttribute
    property column : String
    property value : SetAttributeValue

    def initialize(@column, @value)
    end
  end

  struct SetJSONBValue
    property column : String
    property name : String
    property value : SetAttributeValue

    def initialize(@column, @name, @value)
    end
  end

  @set_attributes = [] of SetAttribute | SetJSONBValue

  getter table_name : String

  def initialize(@table_name)
  end

  def set(column : String, value : SetAttributeValue)
    @set_attributes.push(
      SetAttribute.new(
        column: column,
        value: value,
      )
    )

    self
  end

  def set_json_b(column : String, hash_json : NamedTuple(key: String, value: SetAttributeValue))
    @set_attributes.push(
      SetJSONBValue.new(
        column: column,
        value: hash_json[:value],
        name: hash_json[:key]
      )
    )

    self
  end
end

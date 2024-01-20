class BaseQuery(T)
  include Enumerable(T)

  class RecordNotFound < Exception
  end

  alias WhereConditionType = String | Int32 | Int64 | Bool | Nil

  struct WhereCondition
    property column_condition : String
    property value : WhereConditionType? = nil
    property input_type : Symbol

    def initialize(@column_condition, @value, @input_type)
    end

    def to_query(number : Int32? = 1)
      arg_v = "$#{number}"

      if input_type == :pretty
        "#{column_condition} = #{arg_v}"
      else
        "#{column_condition.gsub("?", arg_v)}"
      end
    end
  end

  getter select_clause : String = "*"
  getter from_clause : String

  def initialize(
    @select_clause : String?,
    @from_clause : String,
  )
    @where_conditions = [] of WhereCondition
  end

  def find(id)
    record = where({"id" => id}).first?

    raise RecordNotFound.new("Record not found") unless record

    record
  end

  def first?
    results[0]
  end

  def where(value : Hash | String, args : (Array(WhereConditionType))? = [] of Int32)
    if value.is_a?(Hash)
      value.keys.each do |key|
        @where_conditions.push(WhereCondition.new(column_condition: key, value: value[key], input_type: :pretty))
      end
    else
      raise "Args are empty" if args.empty?

      @where_conditions.push WhereCondition.new(column_condition: value, value: args[0], input_type: :standard)
    end

    self
  end

  def each(&block : T -> _)
    results.each(&block)
  end

  def results
    args = [] of WhereConditionType

    where_condition = @where_conditions.map_with_index do |where, index|
      args.push(where.value)
      where.to_query(index + 1)
    end.join(" AND ")

    where_clause = where_condition.blank? ? "" : "WHERE #{where_condition}"

    raw = "
      SELECT #{select_clause}
      FROM #{from_clause}
      #{where_clause}
    "

    puts("Executing #{raw.inspect} with args: #{args.inspect}")

    AppDatabase.query_all(raw, args: args, as: T)
  end
end

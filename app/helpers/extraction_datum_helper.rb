module ExtractionDatumHelper
  def make_array(instance, fields_array)

    extraction_data_arr = []
    inst = instance
    loop do
      extraction_data_arr << inst.extraction_data
      break if inst.id == inst.parent_id
      inst = Instance.find(inst.parent_id)
    end

    array = Array.new(fields_array.size,'-')

    extraction_data_arr.each do |extraction_data|
      extraction_data.each do |ext|
        array[fields_array.index(ext.field_name)] = ext.value if array[fields_array.index(ext.field_name)] == '-'
      end
    end

    array
  end


end

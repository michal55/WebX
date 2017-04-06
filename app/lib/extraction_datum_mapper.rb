module ExtractionDatumMapper
  require 'set'

  def ExtractionDatumMapper.get_parents(leaf)
    parents_set = Set.new
    inst = leaf
    while parents_set.exclude?(inst.parent_id)
      parents_set.add(inst.parent_id)
      inst = Instance.find(inst.parent_id)
    end
    Instance.where(id: parents_set.to_a).order('id ASC')
  end

  def ExtractionDatumMapper.get_field_array(leafs)
    fields_set = Set.new
    if leafs.length == 0
      return []
    end

    parents = ExtractionDatumMapper.get_parents(leafs[0])

    parents.each do |parent|
      parent.extraction_data.each do |extraction_data|
        fields_set.add(extraction_data.field_name)
      end
    end

    leafs[0].extraction_data.each do |extraction_data|
        fields_set.add(extraction_data.field_name)
    end

    fields_set.to_a
  end

  def ExtractionDatumMapper.make_row(instance,fields_array)
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

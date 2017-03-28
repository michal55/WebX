class ExtractionDatumController < ApplicationController
  require 'set'

  def index
  	@extraction = Extraction.find(params[:extraction_id])
    @instances = Instance.where(extraction_id: @extraction.id).page params[:page]
  	@extraction_datum_arr = []
    @children = []

    parents_array = get_parents(@instances)
    @parents = Instance.where(id: parents_array)

    @parents.each do |inst|
      @extraction_datum_arr << inst.extraction_data
    end

    @instances.each do |inst|
      @extraction_datum_arr << inst.extraction_data
      unless parents_array.include?(inst.id)
        @children << inst
      end
    end


    @script = Script.find(params[:script_id])
  	@project = Project.find(params[:project_id])

    fields_set = Set.new

    @extraction_datum_arr.each do |inst_data|
      inst_data.each do |item|
        fields_set.add(item.field_name)
      end
    end

    @fields_array = fields_set.to_a

  end

  private

  def get_parents(instances)
    parents_set = Set.new
    instances.each do |i|
      inst = i
      while not parents_set.include?(inst.parent_id)
        parents_set.add(inst.parent_id)
        inst = Instance.find(inst.parent_id)
      end
    end
    parents_set.to_a
  end

end

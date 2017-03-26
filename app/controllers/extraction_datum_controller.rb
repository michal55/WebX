class ExtractionDatumController < ApplicationController
  require 'set'

  def index
  	@extraction = Extraction.find(params[:extraction_id])
    @instances = Instance.where(extraction_id: @extraction.id).page params[:page]
  	@extraction_datum_arr = []

    @instances.each do |inst|
      @extraction_datum_arr << inst.extraction_data
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
end

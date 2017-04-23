class ExtractionDatumController < ApplicationController
  require 'set'
  include ExtractionDatumMapper
  require 'csv'

  def index
    @extraction = Extraction.find(params[:extraction_id])
    @children = Instance.where(extraction_id: @extraction.id).where(is_leaf: true).order('id ASC').page params[:page]

    @script = Script.find(params[:script_id])
  	@project = Project.find(params[:project_id])

    @fields_array = ExtractionDatumMapper.get_field_array(@children)

    respond_to do |format|
        format.html
        format.csv do
          headers['Content-Dsiposition'] = "attachment; filename=\"extraction_data\""
          headers['Content-Type'] ||= 'text/csv'
        end
        format.xlsx do
          render xlsx: 'index', filename: "extraction_data.xlsx"
        end
      end
  end

  def logs
    @extraction = Extraction.find(params[:extraction_id])
    @script = Script.find(params[:script_id])
    @project = Project.find(params[:project_id])

    @logs = Log.search_by_resource(@extraction.id)
    @logs = @logs.page(params[:page]).records

    puts("...\n\n\n",@logs,"\n\n\n...")
    render 'extraction_datum/logs'
  end


end

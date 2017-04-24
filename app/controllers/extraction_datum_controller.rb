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
    if request.method == 'GET'
      @severities = set_by_session
    elsif request.method == 'POST'
      @severities = set_by_params
    end
    @extraction = Extraction.find(params[:extraction_id])
    @script = Script.find(params[:script_id])
    @project = Project.find(params[:project_id])

    @logs = Log.search_by_resource(@extraction.id, @severities)
    @logs = @logs.page(params[:page]).records

    begin
      @logs[0].msg
    rescue Faraday::ConnectionFailed, Elasticsearch::Transport::Transport::Errors::NotFound
      render '_elastic_error'
      return
    end
    render 'extraction_datum/logs'
  end

  private

  def set_by_session()
    if session[:logs_filter] == nil
      session[:logs_filter] = [0,1,2]
    end
    session[:logs_filter]
  end

  def set_by_params()
    sev_array = []
    if params[:logs_filter_debug] == "logs_filter_debug"
      sev_array << 0
    end
    if params[:logs_filter_warning] == "logs_filter_warning"
      sev_array << 1
    end
    if params[:logs_filter_error] == "logs_filter_error"
      sev_array << 2
    end

    session[:logs_filter] = sev_array
    sev_array
  end
end

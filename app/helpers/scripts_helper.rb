module ScriptsHelper
  def pretty_json script
    JSON.pretty_generate(script.xpaths)
  end

  def json_height script
    JSON.pretty_generate(script.xpaths).lines.count
  end

  def select_log_level
    ['debug', 'warning', 'error']
  end

  def api_list_link(script)
    root_url + "api/export/list?token=#{script.project.user.api_key}&id=#{script.id}"
  end

  def api_export_link(script)
    root_url + "api/export/extraction?token=#{script.project.user.api_key}&id=last&script_id=#{script.id}"
  end
end

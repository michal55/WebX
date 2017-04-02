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
end

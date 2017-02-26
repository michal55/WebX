class Log
  include Elasticsearch::Persistence::Model
  include Elasticsearch::Model::Callbacks

  index_name 'webx'
  document_type 'log'

  attribute :msg, String, mapping: { index: "not_analyzed" }
  attribute :severity, Integer, mapping: { index: "not_analyzed" }
  attribute :resource_type, Integer, mapping: { index: "not_analyzed" }
  attribute :resource_id, Integer, mapping: { index: "not_analyzed" }

end
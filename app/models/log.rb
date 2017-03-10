class Log
  include Elasticsearch::Persistence::Model
  include Elasticsearch::Model

  index_name ['webx', Rails.env].join('_')
  document_type 'log'

  attribute :msg, String, mapping: { index: "not_analyzed" }
  attribute :severity, Integer, mapping: { index: "not_analyzed" }
  attribute :resource_type, String, mapping: { index: "not_analyzed" }
  attribute :resource_id, Integer, mapping: { index: "not_analyzed" }

end
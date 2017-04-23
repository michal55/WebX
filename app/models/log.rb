class Log
  include Elasticsearch::Persistence::Model
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  require 'elasticsearch/model'

  index_name ['webx', Rails.env].join('_')
  document_type 'log'

  attribute :msg, String, mapping: { index: "not_analyzed" }
  attribute :severity, Integer, mapping: { index: "not_analyzed" }
  attribute :resource_type, String, mapping: { index: "not_analyzed" }
  attribute :resource_id, Integer, mapping: { index: "not_analyzed" }

  def self.search_by_resource(resource_id,severity_arr)
    Elasticsearch::Model.search(
        {
            "query": {
                "bool": {
                    "must": [
                        { "match":
                              { "resource_id": resource_id}
                        },
                        {
                            "terms": {
                                "severity": severity_arr
                            }
                        }

                    ]
                }
            },
            "sort": { "created_at": { "order": "asc" }}
        }, Log)
  end
end

defmodule Estest.ElasticsearchCluster do
  use Elasticsearch.Cluster, otp_app: :estest
end

defmodule Estest.ElasticsearchStore do
  @behaviour Elasticsearch.Store

  alias Estest.ProductsRepo

  @impl true
  def stream(schema) do
    ProductsRepo.stream(schema)
  end

  @impl true
  def transaction(fun) do
    {:ok, result} = ProductsRepo.transaction(fun, timeout: :infinity)
    result
  end
end

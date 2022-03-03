defmodule EstestWeb.ProductController do
  use EstestWeb, :controller

  def index(conn, params) do
    IO.inspect(params)

    products =
      Estest.ElasticsearchCluster
      |> Elasticsearch.get!("/products/_search")
      |> format_products()

    render(conn, "index.json", products: products)
  end

  defp format_products(%{"hits" => %{"hits" => products}}), do: products
end

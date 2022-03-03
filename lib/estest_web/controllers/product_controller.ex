defmodule EstestWeb.ProductController do
  use EstestWeb, :controller

  def index(conn, params) do
    limit =
      params
      |> Map.get("limit", "10")
      |> String.to_integer()

    %{"count" => total} =
      Estest.ElasticsearchCluster
      |> Elasticsearch.get!("/products/_count")

    {before_param, after_param, from} = create_params(params, limit, total)

    metadata = %{
      total_count: total,
      before: before_param,
      after: after_param
    }

    query = %{
      query: %{match_all: %{}},
      size: limit,
      from: from
    }

    products =
      Estest.ElasticsearchCluster
      |> Elasticsearch.post!("/products/_search", query)
      |> format_products()

    render(conn, "index.json", products: products, metadata: metadata)
  end

  defp format_products(%{"hits" => %{"hits" => products}}), do: products

  defp create_params(%{"before" => before}, limit, _) do
    before = String.to_integer(before)

    cond do
      before - limit > 0 ->
        {before - limit, before, before}

      true ->
        {nil, 11, 1}
    end
  end

  defp create_params(%{"after" => after_param}, limit, total) do
    after_param = String.to_integer(after_param)

    cond do
      after_param + limit < total ->
        {after_param, after_param + limit, after_param}

      true ->
        {after_param, nil, after_param}
    end
  end

  defp create_params(_, _, _) do
    {nil, 11, 1}
  end
end

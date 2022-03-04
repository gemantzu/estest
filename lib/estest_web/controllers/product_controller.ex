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

    query =
      base_query(limit, from)
      |> sort_query(params)
      |> type_query(params)
      |> search_query(params)

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

  defp base_query(limit, from) do
    %{
      query: %{
        bool: %{
          must: [
            %{
              match_all: %{}
            }
          ]
        }
      },
      size: limit,
      from: from
    }
  end

  defp type_query(query, %{"type" => type}) do
    put_in(query, [:query, :bool], %{filter: [%{term: %{type: type}}]})
  end

  defp type_query(query, _), do: query

  defp search_query(query, %{"search" => search_term}) do
    query
  end

  defp search_query(query, _), do: query

  # defp type_query(query, params) do
  #   put_in(query, [:query, :bool], %{filter: filter_terms(params)})
  # end

  # defp filter_terms(%{"network_id" => network_id, "type" => type}) do
  #   [%{term: %{type: type}}, %{term: %{network_id: network_id}}]
  # end

  # defp filter_terms(%{"network_id" => network_id}) do
  #   [%{term: %{network_id: network_id}}]
  # end

  defp sort_query(query, %{"sort" => sort}) do
    Map.put(query, :sort, [sort_field(sort)])
  end

  defp sort_query(query, _), do: query

  defp sort_field("-updated_at"), do: %{updated_at: %{order: :desc}}
  defp sort_field("updated_at"), do: %{updated_at: %{order: :asc}}
  defp sort_field("-sku"), do: %{"sku.keyword" => %{order: :desc}}
  defp sort_field("sku"), do: %{"sku.keyword" => %{order: :asc}}
end

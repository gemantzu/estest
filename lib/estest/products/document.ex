defimpl Elasticsearch.Document, for: Estest.Products.Product do
  def id(product), do: product.id
  def routing(_), do: false

  def encode(product) do
    %{
      sku: product.sku,
      name: product.name,
      primary_unit: product.primary_unit,
      upc: product.upc,
      description: product.description,
      updated_at: product.updated_at,
      type: product.type,
      id: product.id,
      network_id: product.network_id,
      tenant_id: product.tenant_id
    }
  end
end

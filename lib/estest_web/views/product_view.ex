defmodule EstestWeb.ProductView do
  use EstestWeb, :view

  def render("index.json", %{products: products}) do
    %{
      data: render_many(products, __MODULE__, "product.json"),
      metadata: %{
        before: "",
        after: "",
        limit: "",
        total_count: 100
      }
    }
  end

  def render("product.json", %{product: %{"_source" => product}}) do
    %{
      id: product["id"],
      sku: product["sku"],
      name: product["name"],
      primary_unit: product["primary_unit"],
      description: product["description"],
      upc: product["upc"],
      tenant_id: product["tenant_id"],
      type: product["type"],
      updated_at: product["updated_at"]
    }
  end
end

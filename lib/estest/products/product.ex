defmodule Estest.Products.Product do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "products_view" do
    field :tenant_id, Ecto.UUID
    field :network_id, Ecto.UUID
    field :type, Ecto.Enum, values: [:item, :kit]
    field :sku, :string
    field :name, :string
    field :upc, :string
    field :description, :string
    field :primary_unit, :string
    field :status, :string
    field :updated_at, :utc_datetime
  end
end

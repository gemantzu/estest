defmodule Estest.Backfill do
  def create_products(name, numbers, network_id) do
    Enum.map(numbers, &create_product(name, &1, network_id))
  end

  defp create_product(name, num, network_id) do
    network_id = Enum.random([network_id, Ecto.UUID.generate()])

    %{
      sku: "sku #{num}",
      name: "name #{num}",
      primary_unit: Enum.random(["ea", "pl"]),
      upc: "upc #{num}",
      description: "description #{num}",
      updated_at: DateTime.utc_now(),
      type: Enum.random(["kit", "item"]),
      id: Ecto.UUID.generate(),
      network_id: network_id
    }
  end
end

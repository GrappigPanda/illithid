defmodule Illithid.Utils do
  @moduledoc """
  General utilities
  """

  @doc """
  Handles creating a unique server name

  ## Examples
      iex> Utils.create_server_name(["5", "1423"])
      "5-1423"

      iex> Utils.create_server_name(["255", "123412341234"])
      "255-123412341234"
  """
  @spec create_server_name([String.t()]) :: String.t()
  def create_server_name(values) when is_list(values) do
    Enum.join(values, "-")
  end
end

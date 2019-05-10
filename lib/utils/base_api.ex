defmodule Illithid.Utils.BaseAPI do
  @moduledoc false

  @spec get(String.t(), map) :: {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
  def get(url, headers \\ [], options \\ []) do
    HTTPoison.get(url, headers, options)
  end

  @spec post(String.t(), map) :: {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
  def post(url, data, headers \\ [], options \\ []) do
    HTTPoison.post(url, data, headers, options)
  end

  @spec put(String.t(), map) :: {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
  def put(url, data, headers \\ [], options \\ []) do
    HTTPoison.put(url, data, headers, options)
  end

  @spec delete(String.t(), map) :: {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
  def delete(url, headers \\ [], options \\ []) do
    HTTPoison.delete(url, headers, options)
  end
end

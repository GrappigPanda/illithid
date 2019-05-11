defmodule Illithid.Utils.BaseAPI do
  @moduledoc false

  @spec get(String.t(), headers :: [tuple()], options :: []) ::
          {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
  def get(url, headers \\ [], options \\ [])
      when is_binary(url) and is_list(headers) and is_list(options) do
    HTTPoison.get(url, headers, options)
  end

  @spec post(String.t(), data :: String.t(), headers :: [tuple()], options :: []) ::
          {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
  def post(url, data, headers \\ [], options \\ [])
      when is_binary(url) and is_binary(data) and is_list(headers) and is_list(options) do
    HTTPoison.post(url, data, headers, options)
  end

  @spec put(String.t(), data :: String.t(), headers :: [tuple()], options :: []) ::
          {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
  def put(url, data, headers \\ [], options \\ [])
      when is_binary(url) and is_binary(data) and is_list(headers) and is_list(options) do
    HTTPoison.put(url, data, headers, options)
  end

  @spec delete(String.t(), headers :: [tuple()], options :: []) ::
          {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
  def delete(url, headers \\ [], options \\ [])
      when is_binary(url) and is_list(headers) and is_list(options) do
    HTTPoison.delete(url, headers, options)
  end
end

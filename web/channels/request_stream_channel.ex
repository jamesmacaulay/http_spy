defmodule HttpSpy.RequestStreamChannel do
  use HttpSpy.Web, :channel

  def join("requests:" <> slug, _params, socket) do
    {:ok, assign(socket, :slug, slug)}
  end
end

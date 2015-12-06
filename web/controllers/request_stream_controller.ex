defmodule HttpSpy.RequestStreamController do
  use HttpSpy.Web, :controller

  def random_redirect(conn, _) do
    slug = :crypto.strong_rand_bytes(5) |> Base.encode32(case: :lower)
    redirect conn, to: request_stream_path(conn, :spy, slug)
  end

  def spy(conn, %{"slug" => slug}) do
    render conn, "show.html"
  end

  def capture(conn, %{"slug" => slug}) do
    send_resp conn, 200, ""
  end
end

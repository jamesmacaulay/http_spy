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
    conn
    |> send_resp(200, "")
    |> broadcast_request_info(slug)
  end

  defp broadcast_request_info(conn, slug) do
    topic = "requests:" <> slug
    event = "request"
    msg = serializable_request(conn)
    HttpSpy.Endpoint.broadcast(topic, event, msg)
    conn
  end

  def serializable_request(conn) do
    %{
      scheme: conn.scheme,
      method: conn.method,
      host: conn.host,
      port: conn.port,
      path: conn.request_path,
      query_string: conn.query_string,
      headers: serializable_headers(conn.req_headers),
      remote_ip: serializable_ip(conn.remote_ip)
    }
  end

  def serializable_headers(headers) do
    for {k,v} <- headers, do: [k,v]
  end

  def serializable_ip({a,b,c,d}) do
    Enum.join([a,b,c,d], ".")
  end
end

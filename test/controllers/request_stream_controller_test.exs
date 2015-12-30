defmodule HttpSpy.RequestStreamControllerTest do
  use HttpSpy.ConnCase
  use HttpSpy.ChannelCase

  test "GET /" do
    conn = get conn(), "/"
    assert redirected_to(conn) =~ ~r"/[^/]+/spy"
  end

  test "GET /foo/spy" do
    conn = get conn(), "/foo/spy"
    assert html_response(conn, 200) =~ "<div id=\"elm-main\"></div>"
  end

  test "GET /foo with some query params" do
    socket = subscribe_and_join!(socket(), HttpSpy.RequestStreamChannel, "requests:foo")
    conn = get conn(), "/foo?bar=baz"
    assert response(conn, 200) == ""
    assert_broadcast("request", %{method: "GET", path: "/foo", queryString: "bar=baz"})
  end

  test "POST /foo with some data" do
    socket = subscribe_and_join!(socket(), HttpSpy.RequestStreamChannel, "requests:foo")
    conn = conn()
    |> put_req_header("content-type", "application/json")
    |> post "/foo", "{\"bar\": \"baz\"}"
    assert response(conn, 200) == ""
    assert_broadcast("request", %{method: "POST", path: "/foo", body: "{\"bar\": \"baz\"}"})
  end
end

defmodule HttpSpy.RequestStreamControllerTest do
  use HttpSpy.ConnCase

  test "GET /" do
    conn = get conn(), "/foo/spy"
    assert html_response(conn, 200) =~ "<div id=\"elm-main\"></div>"
  end
end

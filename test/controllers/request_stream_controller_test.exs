defmodule Httpspy.RequestStreamControllerTest do
  use Httpspy.ConnCase

  test "GET /" do
    conn = get conn(), "/foo/spy"
    assert html_response(conn, 200) =~ "<div id=\"elm-main\"></div>"
  end
end

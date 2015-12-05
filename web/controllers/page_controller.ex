defmodule Httpspy.PageController do
  use Httpspy.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

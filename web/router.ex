defmodule Httpspy.Router do
  use Httpspy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Httpspy do
    pipe_through :browser
    get "/", RequestStreamController, :random_redirect
    get "/:slug/spy", RequestStreamController, :spy
  end

  get "/:slug", Httpspy.RequestStreamController, :capture
  post "/:slug", Httpspy.RequestStreamController, :capture
  put "/:slug", Httpspy.RequestStreamController, :capture
  patch "/:slug", Httpspy.RequestStreamController, :capture
  delete "/:slug", Httpspy.RequestStreamController, :capture
  options "/:slug", Httpspy.RequestStreamController, :capture
  connect "/:slug", Httpspy.RequestStreamController, :capture
  trace "/:slug", Httpspy.RequestStreamController, :capture
  head "/:slug", Httpspy.RequestStreamController, :capture
end

defmodule HttpSpy.Router do
  use HttpSpy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", HttpSpy do
    pipe_through :browser
    get "/", RequestStreamController, :random_redirect
    get "/:slug/spy", RequestStreamController, :spy
  end

  get "/:slug", HttpSpy.RequestStreamController, :capture
  post "/:slug", HttpSpy.RequestStreamController, :capture
  put "/:slug", HttpSpy.RequestStreamController, :capture
  patch "/:slug", HttpSpy.RequestStreamController, :capture
  delete "/:slug", HttpSpy.RequestStreamController, :capture
  options "/:slug", HttpSpy.RequestStreamController, :capture
  connect "/:slug", HttpSpy.RequestStreamController, :capture
  trace "/:slug", HttpSpy.RequestStreamController, :capture
  head "/:slug", HttpSpy.RequestStreamController, :capture
end

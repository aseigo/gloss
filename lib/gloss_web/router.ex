defmodule GlossWeb.Router do
  use GlossWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GlossWeb do
    pipe_through :browser

    live "/term/:id/:term", PageLive
    live "/", PageLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", GlossWeb do
  #   pipe_through :api
  # end
end

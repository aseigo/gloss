defmodule GlossWeb.PageController do
  use GlossWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

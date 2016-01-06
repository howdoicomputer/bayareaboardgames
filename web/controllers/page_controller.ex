defmodule Bayareaboardgames.PageController do
  use Bayareaboardgames.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

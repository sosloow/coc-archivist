defmodule CocArchivistWeb.PageController do
  use CocArchivistWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/scenarios")
  end
end

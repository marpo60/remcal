defmodule RemcalWeb.PageControllerTest do
  use RemcalWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200)
  end
end

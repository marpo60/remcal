defmodule RemcalWeb.PageController do
  use RemcalWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home)
  end

  def calendar(conn, _params) do
    current_user_id = conn.assigns.current_user.id

    body =
      Remcal.Accounts.list_events(current_user_id)
      |> Remcal.Calendar.events_to_ics()

    conn
    |> put_resp_content_type("text/calendar")
    |> send_resp(200, body)
  end
end

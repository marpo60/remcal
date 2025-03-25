defmodule RemcalWeb.EventLiveTest do
  use RemcalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Remcal.AccountsFixtures

  @create_attrs %{date: "2025-03-30", done: true, description: "some description", title: "some title", reminder_start_date: "2025-03-30"}
  @update_attrs %{date: "2025-03-31", done: false, description: "some updated description", title: "some updated title", reminder_start_date: "2025-03-31"}
  @invalid_attrs %{date: nil, done: false, description: nil, title: nil, reminder_start_date: nil}

  defp create_event(_) do
    user = user_fixture()
    event = event_fixture(%{user_id: user.id})
    %{user: user, event: event}
  end

  describe "Index" do
    setup [:create_event]

    test "lists all events", %{conn: conn, event: event, user: user} do
      {:ok, _index_live, html} = conn
                                 |> log_in_user(user)
                                 |>live(~p"/events")

      assert html =~ "Listing Events"
      assert html =~ event.description
    end

    test "saves new event", %{conn: conn, user: user} do
      {:ok, index_live, _html} = conn
                                 |> log_in_user(user)
                                 |>live(~p"/events")

      assert index_live |> element("a", "New Event") |> render_click() =~
               "New Event"

      assert_patch(index_live, ~p"/events/new")

      assert index_live
             |> form("#event-form", event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#event-form", event: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/events")

      html = render(index_live)
      assert html =~ "Event created successfully"
      assert html =~ "some description"
    end

    test "updates event in listing", %{conn: conn, event: event, user: user} do
      {:ok, index_live, _html} = conn
                                 |> log_in_user(user)
                                 |>live(~p"/events")

      assert index_live |> element("#events-#{event.id} a", "Edit") |> render_click() =~
               "Edit Event"

      assert_patch(index_live, ~p"/events/#{event}/edit")

      assert index_live
             |> form("#event-form", event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#event-form", event: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/events")

      html = render(index_live)
      assert html =~ "Event updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes event in listing", %{conn: conn, event: event, user: user} do
      {:ok, index_live, _html} = conn
                                 |> log_in_user(user)
                                 |>live(~p"/events")

      assert index_live |> element("#events-#{event.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#events-#{event.id}")
    end
  end

  describe "Show" do
    setup [:create_event]

    test "displays event", %{conn: conn, event: event, user: user} do
      {:ok, _show_live, html} = conn
                                 |> log_in_user(user)
                                 |>live(~p"/events/#{event}")

      assert html =~ "Show Event"
      assert html =~ event.description
    end

    test "updates event within modal", %{conn: conn, event: event, user: user} do
      {:ok, show_live, _html} = conn
                                 |> log_in_user(user)
                                 |>live(~p"/events/#{event}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Event"

      assert_patch(show_live, ~p"/events/#{event}/show/edit")

      assert show_live
             |> form("#event-form", event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#event-form", event: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/events/#{event}")

      html = render(show_live)
      assert html =~ "Event updated successfully"
      assert html =~ "some updated description"
    end
  end
end

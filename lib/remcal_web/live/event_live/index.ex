defmodule RemcalWeb.EventLive.Index do
  use RemcalWeb, :live_view

  alias Remcal.Accounts
  alias Remcal.Accounts.Event

  @impl true
  def mount(_params, _session, socket) do
    current_user_id = socket.assigns.current_user.id

    {:ok, stream(socket, :events, Accounts.list_events(current_user_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    current_user_id = socket.assigns.current_user.id

    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Accounts.get_event!(current_user_id, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Events")
    |> assign(:event, nil)
  end

  @impl true
  def handle_info({RemcalWeb.EventLive.FormComponent, {:saved, event}}, socket) do
    {:noreply, stream_insert(socket, :events, event)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    current_user_id = socket.assigns.current_user.id

    event = Accounts.get_event!(current_user_id, id)
    {:ok, _} = Accounts.delete_event(event)

    {:noreply, stream_delete(socket, :events, event)}
  end
end

defmodule Remcal.Calendar do
  def events_to_ics(events) do
    events
    |> Enum.map(&to_calendar_event/1)
    |> to_ics()
  end

  def to_calendar_event(event) do
    %{
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date
    }
  end

  def to_ics(calendar_events) do
    """
    BEGIN:VCALENDAR
    VERSION:2.0
    PRODID:Remcal
    BEGIN:VTIMEZONE
    TZID:America/Montevideo
    X-LIC-LOCATION:America/Montevideo
    BEGIN:STANDARD
    TZOFFSETFROM:-0300
    TZOFFSETTO:-0300
    TZNAME:-03
    DTSTART:19700101T000000
    END:STANDARD
    END:VTIMEZONE
    #{for calendar_event <- calendar_events, do: build_event(calendar_event)}
    END:VCALENDAR
    """
  end

  defp build_event(calendar_event) do
    """
    BEGIN:VEVENT
    DTSTART;TZID=America/Montevideo:#{format_date(calendar_event.date)}
    DTEND;TZID=America/Montevideo:#{format_date(calendar_event.date)}
    SUMMARY:#{calendar_event.title}
    DESCRIPTION:#{calendar_event.description}
    UID:#{calendar_event.id}@remcal.local
    END:VEVENT
    """
  end

  defp format_date(datetime) do
    Calendar.strftime(datetime, "%Y%m%d")
  end
end

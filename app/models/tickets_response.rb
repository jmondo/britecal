class TicketsResponse
  attr_reader :response
  # delegate :events, :to => :tickets

  def initialize(response)
    @response = response
  end

  def tickets
    @tickets ||= Tickets.new(order_data)
  end

  private

  def order_data
    response["user_tickets"][1]["orders"]
  end

end

require 'forwardable'

class Tickets
  extend Forwardable
  def_delegators :tickets, :size, :each, :[]
  include Enumerable
  attr_reader :ticket_objects, :tickets, :events

  def initialize(ticket_objects)
    @ticket_objects = ticket_objects
  end

  def tickets
    @tickets ||= ticket_data.collect { |t| Ticket.new(t) }
  end

  # def events
  #   tickets.map(&:event)
  # end

  def ical_events
    @calendar ||= Cal.new(tickets.map(&:event).map(&:ical)).calendar
  end

  private

  def ticket_data
    ticket_objects.map {|h| h['order']}
  end

end

class Cal
  attr_reader :events

  def initialize(ical_events)
    @events = ical_events
  end

  def calendar
    cal = RiCal.Calendar do
      add_x_property 'X-WR-CALNAME', 'Eventbrite Events'
      add_x_property 'X-WR-CALDESC', 'My feed of eventbrite events, powered by britecal'
    end

    events.each do |ev|
      cal.add_subcomponent(ev)
    end

    cal
  end
end

class Ticket
  attr_reader :ticket

  def initialize(ticket)
    @ticket = ticket
  end

  def event
    Event.new(ticket["event"])
  end
end

class Event
  attr_reader :details, :ical

  def initialize(details)
    @details = details
  end

  def ical
    event = RiCal::Component::Event.new
    event.summary = details['title']
    event.description = details['url']
    event.url = details['url']
    event.dtstart = Time.parse(details['start_date']).set_tzid(details['timezone'])
    event.dtend =  Time.parse(details['end_date']).set_tzid(details['timezone'])
    event.location = [details['venue']['name'], details['venue']['address'], details['venue']['address2'], details['venue']['city'], details['venue']['state'], details['venue']['postal_code'], "(#{details['venue']["Lat-Long"]})"].join(' ')
    event
  end
end

# TicketsResponse(response).tickets[1].event.details
# # TicketsResponse(response).tickets.events
# # TicketsResponse(response).events[1].details


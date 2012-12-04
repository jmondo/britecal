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

  private

  def ticket_data
    ticket_objects.map {|h| h['order']}
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

Event = Struct.new(:details)

# TicketsResponse(response).tickets[1].event.details
# # TicketsResponse(response).tickets.events
# # TicketsResponse(response).events[1].details


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
    event.description = Description.new(url: details['url'], html: details['description']).plain_text
    event.url = details['url']
    event.dtstart = Time.parse(details['start_date']).set_tzid(details['timezone'])
    event.dtend =  Time.parse(details['end_date']).set_tzid(details['timezone'])
    event.location = Address.new(details: details).street_address
    event
  end

end

class Address
  attr_reader :details
  def initialize(options={})
    @details = options[:details]
  end

  def street_address
    attributes.join(' ')
  end

  private

  def attributes
    [
      details['venue']['name'],
      details['venue']['address'],
      details['venue']['address2'],
      details['venue']['city'],
      details['venue']['state'],
      details['venue']['postal_code']
    ]
  end
end

class Description
  attr_reader :url, :html

  def initialize(options = {})
    @url, @html = options[:url], options[:html]
  end

  def plain_text
    @plain_text ||= "#{text_from_doc(massage_doc(noko_doc))} \n\n #{url}"
  end

  private

  def noko_doc
    @doc ||= Nokogiri::HTML(html)
  end

  def manipulate_image_node(node)
    if node.parent && node.parent.name == 'a'
      node.parent.remove
    end
    node.remove
  end

  def massage_doc(doc)
    doc.css('script').each { |node| node.remove }
    doc.css('img').each { |node| manipulate_image_node(node) }
    doc.css('a').each { |node| node.swap("#{node.text} (#{node.attributes['href'].value})") }
    doc.css('br').each { |node| node.swap("\n") }
    doc.css('li').each { |node| node.swap("- #{node.text}") }
    doc
  end

  def text_from_doc(doc)
    doc.css('body').text.squeeze(" ").squeeze("\n")
  end
end

# TicketsResponse(response).tickets[1].event.details
# # TicketsResponse(response).tickets.events
# # TicketsResponse(response).events[1].details


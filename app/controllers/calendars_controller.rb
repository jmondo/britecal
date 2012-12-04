class CalendarsController < ApplicationController
  def show
    eb_client = EventbriteClient.new({ :access_token => current_token })
    tickets = eb_client.user_list_tickets({ :type => "all" }) rescue []
    response = TicketsResponse.new(tickets.parsed_response)
    debugger
    response
  end
end

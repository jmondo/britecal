class CalendarsController < ApplicationController
  def show
    eb_client = EventbriteClient.new({ :access_token => current_user.token })
    tickets = eb_client.user_list_tickets({ :type => "all" }) rescue []
    tickets_response = TicketsResponse.new(tickets.parsed_response)
    debugger;1
    tickets_response
  end
end

class CalendarsController < ApplicationController
  def show
    eb_client = EventbriteClient.new({ :access_token => current_user.token })
    tickets = eb_client.user_list_tickets({ :type => "all" }) rescue []
    render :layout => false,
      :text => TicketsResponse.new(tickets.parsed_response).tickets.ical_events,
      :content_type => 'text/calendar'
  end
end

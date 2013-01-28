class CalendarsController < ApplicationController
  def show
    user = User.find_by_cal_token(params[:cal_token])
    return unless user
    eb_client = EventbriteClient.new({ :access_token => user.token })
    tickets = eb_client.user_list_tickets({ :type => "all" }) rescue []
    render :layout => false,
      :text => TicketsResponse.new(tickets.parsed_response).tickets.ical_events,
      :content_type => 'text/calendar'
  end
end

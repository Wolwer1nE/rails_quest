class Quest3AccessGateController < ApplicationController
  # TODO: Add routes in config/routes.rb and finish the controller logic for Quest 3.
  # The quest expects a mix of GET / POST / PATCH / DELETE, conditional redirects,
  # and visible before_action / after_action callbacks.

  # Quest3DataService probes POST/PATCH/DELETE actions without a browser CSRF token.
  # Disable CSRF verification here so the probe can validate route/controller logic.
  skip_forgery_protection


  # Register callbacks here.
  before_action :calculate_clearance, only: [:clearance]
  after_action :append_inform, only: [:clearance]

  before_action :take_token, only: [:granted]
  after_action :token_checked, only: [:granted]

  def ping
    render plain: "ACCESSGATE PING OK"
  end

  def scan
    agent = params[:agent]
    sector = params[:sector]
    render plain: "SCAN RESULT: #{agent} -> sector #{sector}"
  end

  def power
    current = params[:current].to_i
    boost = params[:boost].to_i
    result = (current + boost).to_s
    render plain: "POWER TOTAL: #{result}"
  end

  def stale_logs
    count = params[:count].to_i
    render plain: "STALE LOGS CLEARED: #{count}"
  end

  def clearance
     render plain: "CLEARANCE TOTAL: #{@clearance_total}"
  end

  def verify
    token = params[:token]
    if token.start_with?("alpha")
      redirect_to "/access_gate/granted?token=#{token}"
    else
       redirect_to "/access_gate/denied?token=#{token}"
    end
  end

  def granted
    render plain: "TOKEN ACCEPTED: #{@token}"
  end

  def denied
    render plain: ""
  end

  private

  def calculate_clearance
    level = params[:level].to_i
    boost = params[:boost].to_i
    @clearance_total = (level + boost).to_s
  end

  def append_inform
    response.set_header("X-Access-Gate-Trace", "CLEAREANCE_GRANTED")
  end

  def take_token
    @token = params[:token]
  end

  def token_checked
    response.set_header("X-Access-Gate-Trace", "token_checked")
  end


  # Implement callbacks here
  # response.set_header("X-Access-Gate-Trace", "") may be helpful
end

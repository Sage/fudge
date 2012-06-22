def rack_session
  unless @rack_session
    @rack_session = Rack::Session::Abstact::SessionHAsh.new
    Rack::Session::Abstract::SessionHash.stub(:new).and_return(@rack_session)
  end
  @rack_session
end

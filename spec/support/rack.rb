require 'rack/session/abstract/id'

def rack_session
  unless @rack_session
    @rack_session = {}
    Rack::Session::Abstract::SessionHash.stub(:new).and_return(@rack_session)
  end
  @rack_session
end

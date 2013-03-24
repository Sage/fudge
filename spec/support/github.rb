require 'json'

class DummyGithubClient
  def initialize(options = {})
    raise ArgumentError unless options[:oauth_token]
  end

  def organizations
    read_json("organizations/response")
  end

  def organization(name)
    organizations.detect do |org|
      org.login == name
    end
  end

  private

  def read_json(path)
    responses = File.expand_path("../responses/", __FILE__)
    response = File.expand_path("#{path}.json", responses)
    json = JSON.parse(File.read(response))
    json.map { |j| Hashie::Mash.new j }
  end
end

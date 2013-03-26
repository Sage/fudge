class Org
  attr_accessor :client

  def initialize(hashie)
    @hashie = hashie
  end

  def name
    @hashie.login
  end

  def repos
    client.organization_repositories(name)
  end
end

class SelfOrg
  def name
    'Your Repos'
  end
end

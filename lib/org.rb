class Org
  def initialize(hashie)
    @hashie = hashie
  end

  def name
    @hashie.login
  end
end

class SelfOrg
  def name
    'Your Repos'
  end
end

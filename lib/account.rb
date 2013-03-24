class Account
  def initialize(github)
    @github = github
  end

  def orgs
    orgs = @github.organizations.map {|o| Org.new(o) }
    orgs << SelfOrg.new
    orgs
  end
end

class Repo < ActiveRecord::Base
  has_many :watched

  def github_path
    return unless self.uri
    self.uri.gsub(/.*:/, '').gsub(/.git$/, '')
  end
end

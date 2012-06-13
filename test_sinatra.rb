require 'sinatra'

get '/' do
  @builds = [
    {status: :pass, name: "Sage One Platform", repo: "git@github.com:Sage/sop.git", id: :sop},
    {status: :warn, count: 3, name: "Soroban", repo: "git@github.com:Sage/soroban.git", id: :soroban, pulls: true},
    {status: :fail, count: 6, name: "My Sage One", repo: "git@github.com:Sage/mysageone.git", id: :mysageone}
  ]
  erb :index
end

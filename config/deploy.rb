set :application, "Brunhilde"
default_run_options[:pty] = true
set :repository,  "http://github.com/jasonpgignac/brunhilde.git"
set :scm, "git"
set :scm_passphrase, "lamia6713"
set :user, "ptadmin"
set :password, "sys051976"
set :runner, "ptadmin"

set :deploy_to, "/Volumes/Repository/brunhilde0.3"

role :web, "ususrl-xsod-004.pcroot.com"
role :db, "ususrl-xsod-004.pcroot.com", :primary => true
role :app, "ususrl-xsod-004.pcroot.com"

deploy.task :restart, :roles => :app do
  run "touch #{current_path}/tmp/restart.txt"
end


set :application, "Brunhilde"
default_run_options[:pty] = true
set :repository,  "git@github.com:jasonpgignac/brunhilde.git"
set :scm, "git"
set :scm_passphrase, "lamia6713"
set :user, "ptadmin"
set :password, "sys051976"
set :runner, "ptadmin"

set :deploy_to, "/Volumes/Untitled/brunhilde0.2"

role :web, "ussatx-xsod-001"
role :db, "ussatx-xsod-001", :primary => true
role :app, "ussatx-xsod-001"

deploy.task :restart, :roles => :app do
  run "touch #{current_path}/tmp/restart.txt"
end


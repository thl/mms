set :application, "ndlb"
set :repository,  "https://ndlb.svn.sourceforge.net/svnroot/ndlb/portal/ror/tags/stable"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/webapps/rails/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "e-bhutan.net"
role :web, "e-bhutan.net"
role :db,  "e-bhutan.net", :primary => true


desc "Task to run the globalize:setup database migration."
task :globalize_setup, :roles => :db do
  run "cd #{deploy_to}/current; rake globalize:setup RAILS_ENV=production"
end


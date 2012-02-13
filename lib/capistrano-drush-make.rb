require 'capistrano/recipes/deploy/strategy/remote_cache'
require 'ash/drupal'

module Capistrano
  module Deploy
    module Strategy

      # Implements the deployment strategy that uses remote cache. Then calls
      # drush make to deploy the drupal code to the final deployment location.
      class DrushMake < RemoteCache
        # Executes the SCM command for this strategy and writes the REVISION
        # mark file to each host.
        def deploy!
          update_repository_cache
          drush_make_repository_cache
        end

        def check!
          super.check do |d|
            d.remote.command("drush")
            d.remote.writable(shared_path)
          end
        end

        private

          def drush_make_repository_cache
            drush_makefile = configuration[:drush_makefile] || 'distro.make'
            logger.trace "Build drush make the cached version to #{configuration[:release_path]}"
            run "drush make #{repository_cache}/#{drush_makefile} #{configuration[:release_path]} && #{mark}"
          end

      end

    end
  end
end


configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
    Capistrano.configuration(:must_exist)

configuration.load do

  after "drupal:symlink","drupal:symlink_default_multisite"

  namespace :deploy do
    desc "Override ash, this is skipped"
    task :setup_local do
      # skip
      logger.info %q<Overrode ash :setup_local system('cp .htaccess htaccess.dist')>
    end
  end

  namespace :drupal do
    desc "Symlink shared directories"
    task :symlink, :roles => :web, :except => { :no_release => true } do
      multisites.each_pair do |folder, url|
        run "ln -nfs #{shared_path}/#{url} #{latest_release}/sites/#{url}"
      end
    end

    desc "Symlink default to multisite"
    task :symlink_default_multisite, :roles => :web, :except => { :no_release => true } do
      run "rm -rf #{latest_release}/sites/default && ln -nfs #{latest_release}/sites/#{default_multisite} #{latest_release}/sites/default"
    end
  end
end

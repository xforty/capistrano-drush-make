require 'capistrano/recipes/deploy/strategy/remote_cache'

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

module Middleman
  module Deploy
    module Strategies
      module Git
        class ForcePush < Base
          def process
            Dir.chdir(build_dir) do
              add_remote_url
              checkout_branch
              commit_branch('-f')
            end
          end

          private

          def add_remote_url
            url = get_remote_url

            `git init`
            `git remote add origin #{url}`
            `git config user.name "#{user_name}"`
            `git config user.email "#{user_email}"`
          end

          def get_remote_url
            remote  = self.remote
            url     = remote

            # check if remote is not a git url
            unless remote =~ /\.git$/
              url = `git config --get remote.#{url}.url`.chop
            end

            # if the remote name doesn't exist in the main repo
            if url == ''
              puts "Can't deploy! Please add a remote with the name '#{remote}' to your repo."
              exit
            end

            url
          end
        end
      end
    end
  end
end

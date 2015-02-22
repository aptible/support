require 'rspec/core/rake_task'

def system!(cmd)
  success = !!system(cmd)
  exitstatus = $CHILD_STATUS.exitstatus
  fail "Command failed (exit #{exitstatus}): #{cmd}" unless success
end

desc 'Tag current HEAD and push to release branch'
task :deploy, [:bucket] => :redirect do |_t, args|
  fail 'No bucket specified' unless args[:bucket]

  # Build site
  system!('bundle exec middleman build')

  # Upload to S3
  opts = '--acl public-read ' \
         '--cache-control max-age=300,s-maxage=300'

  # http://makandracards.com/makandra/15649
  Bundler.with_clean_env do
    system!("aws s3 sync #{opts} build s3://#{args[:bucket]}")
  end
end

task :redirect, [:bucket] do |_t, args|
  fail 'No bucket specified' unless args[:bucket]

  Bundler.with_clean_env do
    ENV['S3_BUCKET'] = args[:bucket]
    puts ENV.keys.join(' ')
    system!('bundle exec middleman s3_redirect')
  end
end

namespace :deploy do
  desc 'Build and deploy site to support.aptible-staging.com'
  task :staging do
    ENV['BASE_URL'] = 'https://support.aptible-staging.com'
    Rake::Task[:deploy].invoke('support.aptible-staging.com')
  end

  desc 'Build and deploy site to support.aptible.com'
  task :production do
    ENV['BASE_URL'] = 'https://support.aptible.com'
    Rake::Task[:deploy].invoke('support.aptible.com')
  end
end

RSpec::Core::RakeTask.new(:spec)

require 'aptible/tasks'
Aptible::Tasks.load_tasks

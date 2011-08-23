
desc 'Run tests'
task :test do
  sh "test/node/node_modules/nodeunit/bin/nodeunit --reporter skip_passed test/node/node_test.coffee"
end

task :default => :test
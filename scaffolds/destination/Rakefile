require "bundler/gem_tasks"
require 'rake/testtask'        

namespace "test" do
  desc "Run all unit tests"    
  Rake::TestTask.new("unit") do |t|     
    t.pattern = "test/unit/**/test*.rb"
    t.libs << 'test'           
  end

  desc "Run all integration tests"
  Rake::TestTask.new("integration") do |t|     
    t.pattern = "test/integration/**/i9n_*.rb"
    t.libs << 'test'           
  end

  desc "Run all integration tests"
  task :i9n => ["test:integration"] do 
  end
end

desc "Run all unit tests"
task :test => ["test:unit"] do
end

desc "Run tests"               
task :default => "test:unit"


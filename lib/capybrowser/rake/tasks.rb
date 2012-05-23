require 'rake'

def default_gem_build_task(gem)
  gem_build_task(gem)
  task(:directories => CapyBrowser::Rake.dependencies) do |t|
    t.reenable
  end
  task :default do |t|
    CapyBrowser::Rake.rake('-T').invoke!
  end
end

# packaging of source code as gem
def gem_build_task(gem,namespace_name=:gems)
  namespace(namespace_name) do
    gem_dir = CapyBrowser::Rake::RelativePath.new('tmp/gems').path
    directory gem_dir

    desc gem.build_description
    task :build => [:directories,gem.name.to_sym ] do |t|
      t.reenable
    end

    desc "Build all gems"
    task :rebuild do |t|
      rm_rf('./tmp/gems')
      Rake::Task["gems:build"].reenable
      Rake::Task["gems:build"].invoke
    end

    desc gem.build_gemfile_description
    task gem.name.to_sym => [gem.gemfile] do |t|
      t.reenable
    end

    file "vendor/cache/#{gem.gemfile}"  => [gem.gemfile_path.relative_path]
    file gem.gemfile_path.relative_path => gem.gemfile
    file gem.gemfile => gem_dir do |t|
      puts gem.invoke!
      rm_rf(gem_dir)
    end
  end
end

def cucumber_environment_profile_tasks(env)
  namespace(env) do
    # task variants for environments
    cucumber_profile_tasks(:http,env,'http://www')
    cucumber_profile_tasks(:ssl,env,'https://www.ssl',"ssl_")
    desc("Run features against all #{env} environments [:http,:ssl]") if ENV['VERBOSE']
    task(:all => ["#{env}:http:all","#{env}:ssl:all"])
  end
end

def verbose_task(description,*args,&block)
  if ENV['VERBOSE']
    desc(description)
    task(*args,&block)
  end
end

def cucumber_profile_tasks(name,env,url,prefix="")
  environments =  [:test,:stage,:int,:live,:production]
  namespace(name) do
    environments.each{|target|
      cucumber_task(target,env,url,prefix)
    }
    verbose_task(
      "Run features against all #{env} environments #{environments.join(", ")}]", {
        :all => environments
      }
    )
  end
end

# add task for hudon/local/ssl features variants
def cucumber_task(target,environment,url,prefix="")
  cuke_task = CapyBrowser::Rake::CucumberTask.new(target,environment,url,prefix)
  desc cuke_task.description
  task( cuke_task.target, [:command_line_arguments] => CapyBrowser::Rake.dependencies) do |task,args|
    args.with_defaults(:command_line_arguments => "")
    puts CapyBrowser::Rake.cucumber(cuke_task.command_line( args.command_line_arguments)).invoke!
  end
end

# register report output directories so rake creates them on demand
CapyBrowser::Rake.rake_directories.each{|dir|
  directory dir
}

require 'ci/reporter/rake/test_unit'
ENV["CI_REPORTS"] = CapyBrowser::Rake::RelativePath.new('tmp/doc/tests/junit').path

# Gem unit test coverage reports
desc "Generate unit test coverage report"
task(:tests => :directories) do |t|
  puts "Junit style xml Results end up here #{ENV['CI_REPORTS']}"
  CapyBrowser::Rake.rcov(Dir.glob("test/**/test*.rb").join(" ")).invoke!
  puts "Completed Tests"
end

desc "Clean generated files"
task(:clean) do
  CapyBrowser::Rake.rake_directories.each{|dir|
    rm_rf dir
  }
end

# acceptance features
#ENV['VERBOSE'] = "true"
namespace(:features) do
  cucumber_task(:sandbox,'sandbox','http://pal.sandbox.dev',"")
  cucumber_environment_profile_tasks(:hudson)
  cucumber_environment_profile_tasks(:local)

  desc("Run features against all environments [:hudson,:local,:sandbox]")
  task(:all => [:tests,"features:hudson:all","features:local:all","features:sandbox"])
end

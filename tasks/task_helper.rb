require 'rake'
require 'rake/testtask'

def env_tests
  env = ENV['TESTS']
  env ||= ""
  env
end

def test_sources
  source_dir = "test"
  sources = env_tests
  if sources.empty?
    sources = %(#{source_dir}/test_*.rb)
  end
  sources
end

def rcov_arguments(sources="")
  "#{rcov_options} #{sources}"
end

def rcov_cmdline
  %(bundle exec rcov #{rcov_arguments(test_sources)})
end


def rcov_options
  rcov  = %(--aggregate tmp/doc/coverage/coverage.data)
  rcov += %( --text-summary --html)
  rcov += %( -o tmp/doc/coverage)
  rcov += %( --exclude gems)
  rcov
end

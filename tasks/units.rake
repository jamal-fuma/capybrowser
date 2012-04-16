desc "Generate unit test coverage report"
task(:run_units_coverage){|t|
  system rcov_cmdline
}

desc "Run Unit Tests"
Rake::TestTask.new(:run_units) { |t|
  t.pattern = test_sources
  t.verbose = true
  t.warning = true
}

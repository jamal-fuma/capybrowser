task :create_directories => [:log_dir,        :report_dirs,    :coverage_dir, :screenshots_dir]
task :remove_directories => [:remove_log_dir, :remove_doc_dir, :remove_screenshots_dir ]

task :doc_dir         => [:tmp_dir]
task :screenshots_dir => [:tmp_dir]
task :log_dir         => [:tmp_dir]

task :coverage_dir    => [:doc_dir]
task :cucumber_dir    => [:doc_dir]

task :html_dir        => [:cucumber_dir]
task :text_dir        => [:cucumber_dir]
task :junit_dir       => [:cucumber_dir]

task :report_dirs     => [:html_dir, :text_dir, :junit_dir]

task :tmp_dir do
  mkdir_p "./tmp"
end

task :log_dir do
  mkdir_p "./tmp/log"
end

task :doc_dir do
  mkdir_p "./tmp/doc"
end

task :screenshots_dir do
  mkdir_p "./tmp/screenshots"
end

task :coverage_dir do
  mkdir_p "./tmp/doc/coverage"
end

task :cucumber_dir do
  mkdir_p "./tmp/doc/cucumber"
end

task :html_dir do
  mkdir_p "./tmp/doc/cucumber/html"
end

task :text_dir do
  mkdir_p "./tmp/doc/cucumber/text"
end

task :junit_dir do
  mkdir_p "./tmp/doc/cucumber/junit"
end

task :remove_log_dir do
  rm_rf "./tmp/log"
end

task :remove_doc_dir do
  rm_rf "./tmp/doc"
end

task :remove_screenshots_dir do
  rm_rf "./tmp/screenshots"
end

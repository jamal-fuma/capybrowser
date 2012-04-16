desc "Open the coverage report in the browser on osx"
task :report do
    system "open tmp/doc/coverage/index.html" if PLATFORM['darwin']
    system "open tmp/doc/cucumber/html/report.html" if PLATFORM['darwin']
end

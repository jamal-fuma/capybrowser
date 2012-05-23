require 'metric_fu'

ENV['CC_BUILD_ARTIFACTS'] = CapyBrowser::Rake::RelativePath.new('tmp/metrics').path

MetricFu::Configuration.run do |config|
  code_dirs = ['lib','features','test']
  config.verbose = true
  config.darwin_txmt_protocol_no_thanks = true
  config.base_directory     = CapyBrowser::Rake::RelativePath.new('tmp/metrics').path
  config.output_directory   = CapyBrowser::Rake::RelativePath.new('tmp/metrics/output').path
  config.data_directory     = CapyBrowser::Rake::RelativePath.new('tmp/metrics/data').path
  config.scratch_directory  = CapyBrowser::Rake::RelativePath.new('tmp/metrics/scratch').path
  config.flay     = { :dirs_to_flay => code_dirs, :minimum_score => 100, :filetypes => ['rb'] }
  config.flog     = { :dirs_to_flog => code_dirs }
  config.reek     = { :dirs_to_reek => code_dirs, :config_file_pattern => nil}
  config.roodi    = { :dirs_to_roodi => code_dirs, :roodi_config => nil }
  config.saikuro  = { :output_directory => CapyBrowser::Rake::RelativePath.new('tmp/metrics').path + '/saikuro', :input_directory => code_dirs, :cyclo => "", :filter_cyclo => "0", :warn_cyclo => "5", :error_cyclo => "7", :formater => "text" }
  config.rcov     = { :environment => 'test', 
                      :test_files => FileList[%w(test/**/test*.rb features/**/*.rb)],
                      :rcov_opts  => %w(--sort coverage --no-html --text-coverage --no-color --profile --rails --exclude /gems/,/Library/,/usr/,spec),
                      :external => nil
  }

  config.rails_best_practices = {}
  config.hotspots = {}
  config.file_globs_to_ignore = []
  config.syntax_highlighting = true #Can be set to false to avoid UTF-8 issues with Ruby 1.9.2 and Syntax 1.0
  config.metrics            = [:roodi, :churn, :reek, :flog, :flay, :rcov,:saikuro]
  config.graphs             = [:roodi, :reek, :flog, :flay, :rcov]
  config.code_dirs          = code_dirs
end

# very slow metrics generation
namespace :metrics do
  desc "Generate all metrics reports"
  task(:all => [:tests]) do
    report = MetricFu.report
    MetricFu.metrics.each {|metric|
      report.add(metric)
    }

    report.save_output(report.to_yaml, MetricFu.base_directory, "report.yml")
    report.save_output(report.to_yaml, MetricFu.base_directory, "#{Time.now.strftime("%Y%m%d")}.yml")
    report.save_templatized_report

    MetricFu.graphs.each {|graph|
      MetricFu.graph.add(graph, MetricFu.graph_engine)
    }

    MetricFu.graph.generate
  end
end

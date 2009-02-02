require 'rubygems'
require 'haml'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'

Rake::RDocTask.new do |rdoc|
  files = ['README.rdoc', 'COPYING.txt', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README.rdoc" # page to start on
  rdoc.title = "PBCore validator Docs"
  rdoc.rdoc_dir = 'html/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
  rdoc.options << '-cutf-8'
  rdoc.options << '-Whttp://git.mlcastle.net/?p=validator.git;a=blob;f=%s;hb=HEAD'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*.rb']
end

rule '.html' => ['.haml'] do |t|
  engine = Haml::Engine.new(File.read(t.source))
  File.open(t.name, "w") do |file|
    file.write engine.to_html
  end
end

desc 'rebuild the web'
task :web

FileList['html/*.haml'].each do |haml|
  task :web => (haml.gsub(/haml$/, 'html'))
end

task :default => [:web, :rdoc]
require 'date'
require 'yaml'

# EDITOR = 'vim'
EDITOR = 'open -a /Applications/MacVim.app'

CONFIG_FILE = './_config.yml'
CONFIG_PRODUCTION_FILE = './_config_production.yml'
CONFIG = YAML.load_documents(File.open(CONFIG_FILE))[0]
SOURCE_DIR = CONFIG['source']
HTML_DIR = CONFIG['destination']

DIARY_INDEX_DIR = "#{SOURCE_DIR}/diary"
DIARY_ENTRIES_DIR = "#{SOURCE_DIR}/_diary_entries"
DIARY_SRCS = FileList["#{DIARY_ENTRIES_DIR}/**/*.md"]
DIARY_PATH = "#{DIARY_ENTRIES_DIR}/%Y/%Y%m/%Y-%m-%d.md"
DIARY_HEADER = <<EOS
---
date: %Y-%m-%d
url: /diary/%Y/%m/%d/
---
EOS

DIARY_INDEX_PATH = "#{DIARY_INDEX_DIR}/%Y/%m/index.html"
DIARY_INDEX_HEADER = <<EOS
---
layout: diary
disp_year: %Y
disp_month: %m
---
EOS

def date_to_diary_path(dt)
  dt.strftime(DIARY_PATH)
end

def date_to_diary_index_path(dt)
  dt.strftime(DIARY_INDEX_PATH)
end

def disp_date_warning(dt)
  msg = ['###'] * 5
  if (Date.today - dt) > 30
    msg[2] += " WARNING: #{dt} is older than 30 days ago"
    puts msg.join("\n")
  end
  if (Date.today - dt) < 0
    msg[2] += " WARNING: #{dt} is newer than today"
    puts msg.join("\n")
  end
end

def commit_push(comment)
  sh "git add --all --verbose ."
  sh "git commit -m '#{comment}' --verbose"
  cd HTML_DIR do
    sh "git add --all --verbose ."
    sh "git commit -m '#{comment}' --verbose"
  end
  sh "git push --all --verbose origin"
end

rule %r|^#{Regexp.escape(DIARY_INDEX_DIR)}/.*\.html$| do |t, args|
  mkdir_p File.dirname(t.name)
  File.open(t.name, mode = "w") { |d|
    d.write Date.strptime(t.name, DIARY_INDEX_PATH).strftime(DIARY_INDEX_HEADER)
  }
end

rule %r|^#{Regexp.escape(DIARY_ENTRIES_DIR)}/.*\.md$| do |t, args|
  mkdir_p File.dirname(t.name)
  File.open(t.name, mode = "w") { |d|
    d.write Date.strptime(t.name, DIARY_PATH).strftime(DIARY_HEADER)
  }
end

desc 'write/edit an entry on [date]'
task :diary, [:date] do |t, args|
  if args.date
    dt = Date.parse(args.date)
    disp_date_warning(dt)
  else
    dt = Date.today
  end

  path = date_to_diary_path(dt)
  Rake::Task[path].invoke
  sh "#{EDITOR} #{path}"
end

desc 'create index files'
task :create_diary_index do
  DIARY_SRCS.each do |f|
    Rake::Task[date_to_diary_index_path(Date.strptime(f, DIARY_PATH))].invoke
  end
end

desc 'build for production using Jekyll'
task :build_production do
  sh "bundle exec jekyll build --config #{CONFIG_FILE},#{CONFIG_PRODUCTION_FILE}"
end

desc 'commit and push to origin'
task :deploy, [:comment] => [:create_diary_index, :build_production] do |t, args|
  fail 'comment not specified' unless args.comment
  commit_push(args.comment)
end

desc 'commit and push diary to origin'
task :deploy_diary => [:create_diary_index, :build_production] do |t|
  commit_push('diary update')
end

__END__

diary_index_paths = DIARY_SRCS.map{ |s|
  yyyy, mm, _ = File.basename(s, '.*').split('-')
  { path: DIARY_INDEX_DIR + "/#{yyyy}/#{mm}/index.html", year: yyyy.to_i, month: mm.to_i }
}.uniq

diary_index_paths.each do |dest|
  directory File.dirname(dest[:path])
  file dest[:path] do |f|
    File.open(f, mode = 'w') { |otf|
      otf.write MONTHLY_INDEX_HEADER % [dest[:year], dest[:month]]
    }
  end
end

task :default => :build_production

desc 'build for production using Jekyll'
task :build_production do
  jekyll_build_production
end

desc 'write/edit an entry on [date]'
task :diary, [:date] do |t, args|
  if args.date
    dt = Date.parse(args.date)
    if (Date.today - dt) > 30
      puts "###"
      puts "###"
      puts "### WARNING: #{dt} is older than 30 days ago"
      puts "###"
      puts "###"
    end
    if (Date.today - dt) < 0
      puts "###"
      puts "###"
      puts "### WARNING: #{dt} is newer than today"
      puts "###"
      puts "###"
    end

    edit_diary dt
  else
    edit_diary Date.today
  end
end

desc 'commit and push to origin'
task :deploy, [:comment] do |t, args|
  fail 'comment not specified' unless args.comment
  commit_push(args.comment)
end

desc 'commit and push diary to origin'
task :deploy_diary do |t|
  commit_push('diary update')
end

def jekyll_build_production
  sh "bundle exec jekyll build --config #{CONFIG_FILE},#{CONFIG_PRODUCTION_FILE}"
end

def generate_diary_index
end

def edit_diary(diary_date)
  [
   [DIARY_PATH, DIARY_HEADER],
   [MONTHLY_INDEX_PATH, MONTHLY_INDEX_HEADER]
  ].each do |p, h|
    path = diary_date.strftime(p)
    mkdir_p File.dirname(path)
    unless File.exist?(path)
      File.open(path, mode = "w") { |d|
        d.write diary_date.strftime(h)
      }
    end
  end

  sh "#{EDITOR} #{diary_file}"
end

def commit_push(comment)
  jekyll_build_production
  sh "git add --all --verbose ."
  sh "git commit -m '#{comment}' --verbose"
  cd HTML_DIR do
    sh "git add --all --verbose ."
    sh "git commit -m '#{comment}' --verbose"
  end
  sh "git push --all --verbose origin"
end

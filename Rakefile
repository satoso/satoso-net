require 'date'

DIARY_PATH = './_source/diary/entries/diary/%Y/%Y%m/%Y%m%d.txt'
DIARY_HEADER = <<EOS

meta-creation_date: %Y-%m-%d
meta-markup: Markdown

EOS
# EDITOR = 'vim'
EDITOR = 'open -a /Applications/MacVim.app'
HTML_DIR = './_site'

task :default => :build

desc 'build using Jekyll'
task :build do
  jekyll_build
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

def jekyll_build
  sh "bundle exec jekyll build"
end

def edit_diary(diary_date)
  diary_file = diary_date.strftime(DIARY_PATH)

  mkdir_p File.dirname(diary_file)
  unless File.exist?(diary_file)
    File.open(diary_file, mode = "w") { |d|
      d.write diary_date.strftime(DIARY_HEADER)
    }
  end

  sh "#{EDITOR} #{diary_file}"
end

def commit_push(comment)
  jekyll_build
  sh "git add --all --verbose ."
  sh "git commit -m '#{comment}' --verbose"
  cd HTML_DIR do
    sh "git add --all --verbose ."
    sh "git commit -m '#{comment}' --verbose"
  end
  sh "git push --verbose origin master"
  sh "git push --verbose origin html"
end

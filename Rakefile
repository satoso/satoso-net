require 'date'

DIARY_PATH = './_source/diary/entries/diary/%Y/%Y%m/%Y%m%d.txt'
DIARY_HEADER = <<EOS

meta-creation_date: %Y-%m-%d
meta-markup: Markdown

EOS
# EDITOR = 'vim'
EDITOR = 'open -a /Applications/MacVim.app'
HTML_DIR = './_site'

desc 'write/edit an entry on [date]'
task :diary, [:date] do |t, args|
  if args.date
    edit_diary Date.parse(args.date)
  else
    edit_diary Date.today
  end
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

desc 'commit and push to origin'
task :deploy, [:comment] do |t, args|
  fail 'comment not specified' unless args.comment
  commit_push(args.comment)
end

desc 'commit and push diary to origin'
task :deploy_diary do |t|
  commit_push('diary update')
end

def commit_push(comment)
  sh "bundle exec jekyll build"
  sh "git add --all --verbose ."
  sh "git commit -m '#{comment}' --verbose"
  cd HTML_DIR do
    sh "git add --all --verbose ."
    sh "git commit -m '#{comment}' --verbose"
  end
  sh "git push --all --verbose origin"
end

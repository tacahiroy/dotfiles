task :default => "none"

task :none do
  puts 'default task is unavailabled.'
end

def rm(f)
  return unless FileTest.exist?(f)
  mv f, "#{ENV['HOME']}/.Trash/#{File.basename(f)}_#{Time.now.to_i}"
end

def unlink(f)
  return unless FileTest.symlink?(f)
  `unlink #{f}`
end

# rake mklink dir=foo
desc "create symlink"
task :mksymlink do
  FileList['_*'].each do |src|
    dest = "#{ENV['HOME']}/.#{src[1..-1]}"
    src, dest = File.expand_path(src), File.expand_path(dest)
    rm dest if FileTest.exist?(dest)
    unlink dest if FileTest.symlink?(dest)
    ln_s src, dest
  end

  Rake::Task[:mkunmanageddirs].invoke
end

desc "create symlink(dry run)"
task :testmksymlink do
  FileList['_*'].each do |src|
    dest = "#{ENV['HOME']}/.#{src[1..-1]}"
    src, dest = File.expand_path(src), File.expand_path(dest)
    puts "#{src} => #{dest}"
  end
end

task :mkunmanageddirs do
  %w(backups swaps).each do |d|
    dest = "#{ENV['HOME']}/.vim/#{d}"
    mkdir "#{ENV['HOME']}/.vim/#{d}" unless File.exist?(dest)
  end
end

desc "create symlinks to sandbox directory"
task :link2sandbox do
  plugins = %w(ctrlp-funky
               ctrlp-ssh
               vim-bestfriend
  )
  proj = "#{ENV['HOME']}/Projects/vim"
  sandbox = "#{ENV['HOME']}/.vim/sandbox"

  plugins.each do |plugin|
    ln_s "#{proj}/#{plugin}", "#{sandbox}/#{plugin}" unless File.symlink?("#{sandbox}/#{plugin}")
  end
end


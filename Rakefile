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
end

desc "create symlink"
task :testmksymlink do
  FileList['_*'].each do |src|
    dest = "#{ENV['HOME']}/.#{src[1..-1]}"
    src, dest = File.expand_path(src), File.expand_path(dest)
    puts "#{src} => #{dest}"
  end
end

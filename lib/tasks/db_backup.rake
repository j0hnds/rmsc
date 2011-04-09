namespace :db do

  desc "Backup the database to a file. Options: DIR=base_dir, RAILS_ENV=production, MAX=20"
  task :backup => [:environment] do
    datestamp = Time.now.strftime("%Y%m%d_%H%M%S")

    backup_base = File.join('db', 'backup')

    db_config = ActiveRecord::Base.configurations[RAILS_ENV]

    db_name = db_config['database']

    backup_file = File.join(backup_base, "#{datestamp}_#{db_name}_#{RAILS_ENV}_dump.sql.gz")

    FileUtils.mkdir_p backup_base

    pass = ''
    pass = "'-p#{db_config['password']}'" if db_config['password']

    ssl = ''
    ssl = "--ssl-ca=#{db_config['sslca']} --ssl-key=#{db_config['sslkey']} --ssl-cert=#{db_config['sslcert']}" if db_config['sslca']

    host = ''
    host = "-h #{db_config['host']}" if db_config['host']

    sh "mysqldump -u #{db_config['username']} #{pass} #{host} #{ssl} #{db_config['database']} -Q --add-drop-table -O add-locks=FALSE -O lock-tables=FALSE | gzip -c > #{backup_file}"

    dir = Dir.new backup_base

    all_backups = dir.entries[2..-1].sort.reverse

    puts "Created backup: #{backup_file}"

    max_backups = (ENV['MAX'] || 20).to_i

    unwanted_backups = all_backups[max_backups..-1] || []
    unwanted_backups.each do | unwanted_backup |
      FileUtils.rm_rf File.join(backup_base, unwanted_backup)
      puts "Deleted #{unwanted_backup}"
    end

    puts "Deleted #{unwanted_backups.length} backups, #{all_backups.length - unwanted_backups.length} backups available"
  end
end
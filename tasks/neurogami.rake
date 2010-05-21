
def reindex
  puts `rsh -l james_ng neurogami.com  "cd /var/www/vhosts/neurogami.com/httpdocs;  gem generate_index"`
end

def  upload
  puts `scp -v pkg/*.gem james_ng@neurogami.com:/var/www/vhosts/neurogami.com/httpdocs/gems/`  
end


def browse_to sites, browser = :ff
  sites = [sites] if sites.is_a?(String)
  cmd = case browser
        when :ff
          site_list  = sites.map{|s| " '" + s  + "'" }.join(' ')
      'firefox ' + site_list  +  ' &'
        when :chrome
          site_list  = sites.map { |s| '"' + s.strip + '"'  }.join( ' ' )
          # Hack
          'chrome; /home/james/data/vendor/chrome-linux/chrome  --new-window --enable-plugins  ' + site_list  +  ' &'
        else
          site_list  = sites.map{|s| " '" + s  + "'" }.join(' ')
      'firefox ' + site_list  +  ' &'
        end

  Thread.new {
    warn "Opening #{cmd} ..."
    `#{cmd}` 
  }
  sleep 5
end

namespace :ng do
  namespace :gem do

    desc "Uploads gem to neurogami.com"
    task :upload do
      puts `scp -v pkg/*.gem james_ng@neurogami.com:/var/www/vhosts/neurogami.com/httpdocs/gems/`  
    end

    desc "Re-gen the gem index on neurogami.com"
    task :reindex do
      puts `rsh -l james_ng neurogami.com  "cd /var/www/vhosts/neurogami.com/httpdocs;  gem generate_index"`
    end
  end
end

namespace :dev do

  desc "Open sites"
  task :sites do

    if defined? @dev_sites
      @browser_choice ||= :ff
      browse_to @dev_sites, @browser_choice
    else
      puts "You need to edit Rakefile or #{__FILE__} to define @dev_sites."
      puts "Assign to it an array of URLs you wish to open."
      puts "Also, set @browser_choice to either :ff or :chrome to set the browser.\n The default is :ff"
    end

  end

end



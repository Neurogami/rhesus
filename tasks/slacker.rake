namespace :pivotal do

  desc "Fetch and display stories"
  task :stories do 
   sh 'pivotal_slacker stories'
  end

  desc "Upload stories from a local file. Pass in FILE value"
  task :upload do 
   sh "pivotal_slacker upload #{ENV['FILE']}"
  end

end


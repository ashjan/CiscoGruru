namespace :etc do
  desc "precompiles assets for chrome application"
  task :precompile_assets_for_chrome_app => :environment do
    compile_assets_to "../chrome-app/assets"
    system("cp ../cosql/cosql.js ../chrome-app/")
  end

  desc "precompiles assets for enterprise application"
  task :precompile_assets_for_enterprise => :environment do
    compile_assets_to "../enterprise/public/assets"
  end

  desc "precompiles assets for golang app"
  task :precompile_assets_for_go => :environment do
    compile_assets_to "../../goprojects/src/github.com/cenan/dbdesigner/static"
  end

  def compile_assets_to directory
    temp_dir = "tmp/assets"
    target_dir = directory
    # http://stackoverflow.com/a/7286870/554246
    Rails.application.config.assets.prefix = "../#{temp_dir}"
    Rails.application.config.assets.manifest = File.join(Rails.public_path, "../#{temp_dir}")
    system("rm -rf #{temp_dir}")
    ::Rake.application['assets:clean'].invoke
    ::Rake.application['assets:precompile'].invoke
    system("cp -R #{temp_dir}/* #{target_dir}")
    system("rm #{target_dir}/application.js")
    system("rm #{target_dir}/application.css")
    system("mv #{target_dir}/application*.js #{target_dir}/application.js")
    system("mv #{target_dir}/application*.css #{target_dir}/application.css")
  end
end
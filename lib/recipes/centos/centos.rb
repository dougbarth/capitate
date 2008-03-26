# Custom tasks for centos OS profiles
namespace :centos do

  # Add user for an application
  desc <<-DESC
  Add user and set user password for application. Adds user to specified groups. 
  
  <dl>
  <dt>user_add</dt>
  <dd>User to add.</dd>
  <dd>@set :user_add, "app_user"@</dd>

  <dt>groups</dt>
  <dd>Groups for user to be in.</dd>
  <dd class="default">Defaults to @nil@</dd>
  <dd>@set :groups, "admin,foo"@</dd>
  
  <dt>home</dt>
  <dd>Home directory for user.</dd>
  <dd class="default">Defaults to @:deploy_to@ setting_</dd>  
  <dd>@set :home, "/var/www/apps/app_name"@</dd>
  
  <dt>home_readable</dt>
  <dd>Whether home permissions are readable by all. Needed if using deploy dir as home.</dd>
  <dd class="default">Defaults to @true@</dd>
  <dd>@set :home_readable, true@</dd>
  
  </dl>
  DESC
  task :add_user do
    
    # Settings
    fetch(:user_add)
    fetch_or_default(:groups, nil)
    fetch_or_default(:home, deploy_to)
    fetch_or_default(:home_readable, true)
    
    adduser_options = []
    adduser_options << "-d #{home}" unless home.blank?
    adduser_options << "-G #{groups}" unless groups.blank?
  
    user_existed = false
    run "id #{user_add} || /usr/sbin/adduser #{adduser_options.join(" ")} #{user_add}" do |channel, stream, data|
      logger.info data
      user_existed = data =~ /uid/
    end
    
    logger.info "User already existed, aborting..." if user_existed
    
    unless user_existed
      run "chmod a+rx #{home}" if home_readable
  
      new_password = prompt.password("Password to set for #{user_add}: ", :verify => true, :lazy => false)
  
      run "passwd #{user_add}" do |channel, stream, data|
        logger.info data
  
        if data =~ /password:/i
          channel.send_data "#{new_password}\n"
          channel.send_data "#{new_password}\n"
        end
      end
    end
        
  end
              
end
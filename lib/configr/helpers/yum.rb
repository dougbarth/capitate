# Yum capistrano helpers
module Configr::Helpers::Yum
  
  # Update all installed packages
  def yum_update
    sudo "yum -y update"
  end
    
  # Remove via yum.
  def yum_remove(packages)
    sudo "yum -y remove #{packages.join(" ")}"    
  end
  
  # Install via yum.
  # If package already exists, it will be updated (unless update_existing = false).
  def yum_install(packages, update_existing = true)    
    if update_existing
      
      installed_packages = []
      
      sudo "yum -d 0 list installed #{packages.join(" ")}" do |channel, stream, data|
        installed_packages += data.split("\n")[1..-1].collect { |line| line.split(".").first }
      end      
    
      packages -= installed_packages
    
      sudo "yum -y update #{installed_packages.join(" ")}" unless installed_packages.blank?
    end
    
    sudo "yum -y install #{packages.join(" ")}" unless packages.blank?
  end
  
  # Clean yum
  def yum_clean
    sudo "yum -y clean all"
  end
  
end
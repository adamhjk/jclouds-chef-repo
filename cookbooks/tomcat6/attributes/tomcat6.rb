
set[:tomcat6][:basedir]         = "/usr/local"
set[:tomcat6][:package]         = "#{tomcat6[:basedir]}/package"
set[:tomcat6][:home]            = "#{tomcat6[:basedir]}/tomcat6"
set[:tomcat6][:conf]            = "#{tomcat6[:home]}/conf"
set[:tomcat6][:temp]            = "#{tomcat6[:home]}/temp"
set[:tomcat6][:logs]            = "#{tomcat6[:home]}/logs"
set[:tomcat6][:bin]             = "#{tomcat6[:home]}/bin"
set[:tomcat6][:webapps]         = "#{tomcat6[:home]}/webapps"
set[:tomcat6][:manager_dir]     = "#{tomcat6[:webapps]}/manager"
set[:tomcat6][:user]            = "tomcat"
set[:tomcat6][:port]            = 8080
set[:tomcat6][:ssl_port]        = 8433

case platform
when "os_x"
  set_unless[:tomcat6][:java_home]       = "/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home"
  set_unless[:tomcat6][:webapp_base_dir] = "~/Applications"
else
  set_unless[:tomcat6][:java_home]       = "/usr/lib/jvm/java"
  set_unless[:tomcat6][:webapp_base_dir] = "/var/srv"
end

set_unless[:tomcat6][:version]           = "6.0.26"
set_unless[:tomcat6][:manager_user]      = "manager"
set_unless[:tomcat6][:manager_password]  = "manager"

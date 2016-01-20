#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook Name:: php
# Attribute:: default
#
# Copyright 2011-2015, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

lib_dir = 'lib'
default['php']['install_method'] = 'package'
default['php']['directives'] = {}
default['php']['bin'] = 'php'

default['php']['pear'] = 'pear'
default['php']['pecl'] = 'pecl'

case node['platform_family']
when 'rhel', 'fedora'
  lib_dir = node['kernel']['machine'] =~ /x86_64/ ? 'lib64' : 'lib'
  default['php']['conf_dir']          = '/etc'
  default['php']['ext_conf_dir']      = '/etc/php.d'
  default['php']['fpm_user']          = 'nobody'
  default['php']['fpm_group']         = 'nobody'
  default['php']['fpm_listen_user']   = 'nobody'
  default['php']['fpm_listen_group']  = 'nobody'
  default['php']['ext_dir']           = "/usr/#{lib_dir}/php/modules"
  default['php']['src_deps']          = %w(bzip2-devel libc-client-devel curl-devel freetype-devel gmp-devel libjpeg-devel krb5-devel libmcrypt-devel libpng-devel openssl-devel t1lib-devel mhash-devel)
  if node['platform_version'].to_f < 6
    default['php']['packages'] = %w(php53 php53-devel php53-cli php-pear)
    default['php']['mysql']['package'] = 'php53-mysql'
  else
    default['php']['packages'] = %w(php php-devel php-cli php-pear)
    default['php']['mysql']['package']  = 'php-mysql'
    default['php']['fpm_package']       = 'php-fpm'
    default['php']['fpm_pooldir']       = '/etc/php-fpm.d'
    default['php']['fpm_default_conf']  = '/etc/php-fpm.d/www.conf'
    default['php']['fpm_service']       = 'php-fpm'
    if node['php']['install_method'] == 'package'
      default['php']['fpm_user']        = 'apache'
      default['php']['fpm_group']       = 'apache'
      default['php']['fpm_listen_user'] = 'apache'
      default['php']['fpm_listen_group']= 'apache'
    end
  end
when 'debian'
  default['php']['conf_dir'] = '/etc/php5/cli'
  case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f >= 12.10
      default['php']['ext_conf_dir'] = '/etc/php5/mods-available'
    else
      default['php']['ext_conf_dir'] = '/etc/php5/conf.d'
    end
  else
    default['php']['ext_conf_dir'] = '/etc/php5/conf.d'
  end
  default['php']['src_deps']        = %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev)
  default['php']['packages']        = %w(php5-cgi php5 php5-dev php5-cli php-pear)
  default['php']['mysql']['package'] = 'php5-mysql'
  default['php']['fpm_package']     = 'php5-fpm'
  default['php']['fpm_pooldir']     = '/etc/php5/fpm/pool.d'
  default['php']['fpm_user']        = 'www-data'
  default['php']['fpm_group']       = 'www-data'
  default['php']['fpm_listen_user'] = 'www-data'
  default['php']['fpm_listen_group']= 'www-data'
  default['php']['fpm_service']     = 'php5-fpm'
  default['php']['fpm_default_conf'] = '/etc/php5/fpm/pool.d/www.conf'
when 'suse'
  default['php']['conf_dir']        = '/etc/php5/cli'
  default['php']['ext_conf_dir']    = '/etc/php5/conf.d'
  default['php']['src_deps']        = %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev)
  default['php']['fpm_user']        = 'wwwrun'
  default['php']['fpm_group']       = 'www'
  default['php']['fpm_listen_user'] = 'wwwrun'
  default['php']['fpm_listen_group']= 'www'
  default['php']['packages']        = %w(apache2-mod_php5 php5-pear)
  default['php']['mysql']['package'] = 'php5-mysql'
  lib_dir = node['kernel']['machine'] =~ /x86_64/ ? 'lib64' : 'lib'
when 'windows'
  default['php']['windows']['msi_name']      = 'PHP 5.3.28'
  default['php']['windows']['msi_source']    = 'http://windows.php.net/downloads/releases/php-5.3.28-nts-Win32-VC9-x86.msi'
  default['php']['bin']           = 'php.exe'
  default['php']['conf_dir']      = 'C:\Program Files (x86)\PHP'
  default['php']['ext_conf_dir']  = node['php']['conf_dir']
  # These extensions are installed by default by the GUI MSI
  default['php']['packages']      = %w(cgi ScriptExecutable PEAR
                                       iis4FastCGI ext_php_bz2 ext_php_curl
                                       ext_php_exif ext_php_gd2 ext_php_gettext
                                       ext_php_gmp ext_php_imap ext_php_mbstring
                                       ext_php_mysql ext_php_mysqli ext_php_openssl
                                       ext_php_pdo_mysql ext_php_pdo_odbc ext_php_pdo_sqlite
                                       ext_php_pgsql ext_php_soap ext_php_sockets
                                       ext_php_sqlite3 ext_php_tidy ext_php_xmlrpc
                                    )
  default['php']['package_options'] = '' # Use this to customise your yum or apt command
  default['php']['pear']          = 'pear.bat'
  default['php']['pecl']          = 'pecl.bat'
when 'freebsd'
  default['php']['conf_dir']        = '/usr/local/etc'
  default['php']['ext_conf_dir']    = '/usr/local/etc/php'
  default['php']['src_deps']        = %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev)
  default['php']['fpm_user']        = 'www'
  default['php']['fpm_group']       = 'www'
  default['php']['fpm_listen_user'] = 'www'
  default['php']['fpm_listen_group']= 'www'
  default['php']['packages']        = %w( php56 pear )
  default['php']['mysql']['package'] = 'php56-mysqli'
else
  default['php']['conf_dir']        = '/etc/php5/cli'
  default['php']['ext_conf_dir']    = '/etc/php5/conf.d'
  default['php']['src_deps']        = %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev)
  default['php']['fpm_user']        = 'www-data'
  default['php']['fpm_group']       = 'www-data'
  default['php']['fpm_listen_user'] = 'www-data'
  default['php']['fpm_listen_group']= 'www-data'
  default['php']['packages']        = %w(php5-cgi php5 php5-dev php5-cli php-pear)
  default['php']['mysql']['package'] = 'php5-mysql'
end

default['php']['url'] = 'http://us1.php.net/get'
default['php']['version'] = '5.6.13'
default['php']['checksum'] = '92acc6c067f5e015a6881b4119eafec10eca11722e810f2c2083f72e17119bcf'
default['php']['prefix_dir'] = '/usr/local'

default['php']['configure_options'] = %W(--prefix=#{php['prefix_dir']}
                                         --with-libdir=#{lib_dir}
                                         --with-config-file-path=#{php['conf_dir']}
                                         --with-config-file-scan-dir=#{php['ext_conf_dir']}
                                         --with-pear
                                         --enable-fpm
                                         --with-fpm-user=#{php['fpm_user']}
                                         --with-fpm-group=#{php['fpm_group']}
                                         --with-zlib
                                         --with-openssl
                                         --with-kerberos
                                         --with-bz2
                                         --with-curl
                                         --enable-ftp
                                         --enable-zip
                                         --enable-exif
                                         --with-gd
                                         --enable-gd-native-ttf
                                         --with-gettext
                                         --with-gmp
                                         --with-mhash
                                         --with-iconv
                                         --with-imap
                                         --with-imap-ssl
                                         --enable-sockets
                                         --enable-soap
                                         --with-xmlrpc
                                         --with-libevent-dir
                                         --with-mcrypt
                                         --enable-mbstring
                                         --with-t1lib
                                         --with-mysql
                                         --with-mysqli=/usr/bin/mysql_config
                                         --with-mysql-sock
                                         --with-sqlite3
                                         --with-pdo-mysql
                                         --with-pdo-sqlite)

default['php']['ini']['template'] = 'php.ini.erb'
default['php']['ini']['cookbook'] = 'php'

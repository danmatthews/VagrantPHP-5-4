class laravel_app
{

	package { 'git-core':
    	ensure => present,
    }

    exec { 'download wget' :
    	command => "/bin/sh -c 'apt-get install wget'",
    	require => Exec['apt-get update']
    }

    exec { 'download drush' :
    	command => "/bin/sh -c 'cd /opt && wget http://ftp.drupal.org/files/projects/drush-7.x-5.9.tar.gz'",
    	require => [ Exec['apt-get update'], Exec['download wget'] ]
    }

    exec { 'untar drush' :
    	command => "/bin/tar -xvzf drush-7.x-5.9.tar.gz",
    	cwd => '/opt/',
    	require => Exec['download drush']
    }

	file { '/opt/drush/lib':
		mode => 0777
	}

    exec { 'remove drush tar' :
    	command => "sudo /bin/rm /opt/drush-7.x-5.9.tar.gz",
    	require => Exec['untar drush']
    }

    exec { 'symlink drush' :
    	command => "/bin/sh -c 'ln -s /opt/drush/drush /usr/bin/drush'",
    	require => Exec['untar drush']
    }

   	exec { 'install composer':
	    command => 'curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin',
	    require => Package['php5-cli'],
	}

	exec { 'global composer':
		command => "sudo mv /usr/local/bin/composer.phar /usr/local/bin/composer",
		require => Exec['install composer'],
	}

	# exec { 'get laravel packages':
	# 	command => "composer install'",
	# 	cwd => '/var/www/',
	# 	require => [Exec['global composer'], Package['git-core']],
	# 	timeout => 900,
	# }

#	exec { 'get laravel packages':
#		command => "/bin/sh -c 'cd /var/www/ && composer install'",
#		require => [Exec['global composer'], Package['git-core']],
#		creates => "/var/www/composer.lock",
#		timeout => 900,
#	}

#	exec { 'remove optimized class loader':
#		command => "/bin/sh -c 'rm /var/www/bootstrap/compiled.php'",
#		onlyif => "[ -f /var/www/bootstrap/compiled.php ]"
#	}

#	exec { 'get laravel updates':
#        command => "/bin/sh -c 'cd /var/www/ && composer update'",
#        require => [Exec['get laravel packages'], Exec['remove optimized class loader'], Package['git-core']],
#        timeout => 900,
#	}

#	file { '/var/www/app/storage':
#		mode => 0777
#	}
}

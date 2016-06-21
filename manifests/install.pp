# == Class: drupal::install
#
# Install all requirements of the Drupal module.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class drupal::install inherits drupal {

  $drush_download_url = "https://github.com/drush-ops/drush/releases/download/${drupal::drush_version}/drush.phar"

  $drush_filename = "drush-${drupal::drush_version}.phar"
  $drush_install_dir = "${drupal::install_dir}/drush"
  $drush_install_path = "${drush_install_dir}/${drush_filename}"

  file { $drupal::install_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { $drupal::config_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { $drupal::log_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { $drush_install_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  archive { $drush_install_path:
    ensure        => present,
    extract       => true,
    extract_path  => $drush_install_dir,
    source        => $drush_download_url,
    checksum      => $drupal::drush_archive_checksum,
    checksum_type => $drupal::drush_archive_checksum_type,
    require       => File[$drupal::install_dir],
  }

  ->

  file { $drush_install_path:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  ->

  file { $drupal::drush_path:
    ensure => link,
    target => $drush_install_path,
  }

  file { $drupal::update_script_path:
    ensure  => file,
    content => template($drupal::update_script_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}

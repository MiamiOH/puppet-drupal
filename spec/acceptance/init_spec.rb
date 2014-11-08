require 'spec_helper_acceptance'

describe 'by default' do
  specify 'should provision with no errors' do
    pp = <<-EOS
      # just a bunch of dependencies
      file { '/var/www':
        ensure => directory,
      }

      # test manifest
      class { 'drupal': }

      drupal::site { 'drupal-6.x':
        core_version => '6.33',
        modules      => {
          'cck'   => {
            'download' => {
              'type' => 'file',
              'url'  => 'http://ftp.drupal.org/files/projects/cck-6.x-2.9.tar.gz',
              'md5'  => '9e30f22592b7ecf08d020e0c626efc5b',
            },
          },
          'views' => '2.16',
        },
        themes       => {
          'marinelli' => {
            'download' => {
              'type'     => 'git',
              'url'      => 'git://git.drupal.org/project/marinelli.git',
              'revision' => 'fef7745f64541cbe8c746167d3fe37dca133b87b',
            },
          },
          'zen'   => '2.1',
        },
      }

      drupal::site { 'drupal-7.x':
        core_version => '7.32',
        modules      => {
          'ctools'   => {
            'download' => {
              'type'     => 'git',
              'url'      => 'git://git.drupal.org/project/ctools.git',
              'revision' => '5438b40dbe532af6a7eca891c86eaef845bff945',
            },
          },
          'pathauto' => {
            'version' => '1.2',
            'patch'   => [
              'https://www.drupal.org/files/pathauto_admin.patch'
            ],
          },
          'views'    => '3.8',
        },
        themes       => {
          'omega' => '4.3',
          'zen'   => {
            'download' => {
              'type' => 'file',
              'url'  => 'http://ftp.drupal.org/files/projects/zen-7.x-5.5.tar.gz',
              'md5'  => '9ca3c99dedec9bfb1cc73b360990dad9',
            },
          },
        },
        libraries    => {
          'jquery_ui' => {
            'download' => {
              'type' => 'file',
              'url'  => 'http://jquery-ui.googlecode.com/files/jquery.ui-1.6.zip',
              'md5'  => 'c177d38bc7af59d696b2efd7dda5c605',
            },
          },
        },
      }
    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end

  describe file('/usr/local/bin/composer') do
    specify { should be_file }
    specify { should be_executable }
  end

  describe file('/opt/drupal.org/drush') do
    specify { should be_directory }
  end

  describe file('/usr/local/bin/drush') do
    specify { should be_file }
    specify { should be_executable }
  end

  describe file('/etc/drupal/drupal-6.x.make') do
    specify { should be_file }
  end

  describe file('/etc/drupal/drupal-7.x.make') do
    specify { should be_file }
  end

  describe file('/var/www/drupal-6.x') do
    specify { should be_directory }
  end

  describe file('/var/www/drupal-6.x/modules/system/system.info') do
    its(:content) { should match /version = "6.33"/ }
  end

  describe file('/var/www/drupal-6.x/sites/all/modules/cck/content.info') do
    its(:content) { should match /version = "6.x-2.9"/ }
  end

  describe file('/var/www/drupal-6.x/sites/all/modules/views/views.info') do
    its(:content) { should match /version = "6.x-2.16"/ }
  end

  describe file('/var/www/drupal-6.x/sites/all/themes/marinelli/marinelli.info') do
    its(:content) { should match /version = "6.x-1.7"/ }
  end

  describe file('/var/www/drupal-6.x/sites/all/themes/zen/zen.info') do
    its(:content) { should match /version = "6.x-2.1"/ }
  end

  describe file('/var/www/drupal-7.x') do
    specify { should be_directory }
  end

  describe file('/var/www/drupal-7.x/modules/system/system.info') do
    its(:content) { should match /version = "7.32"/ }
  end

  describe file('/var/www/drupal-7.x/sites/all/modules/ctools/ctools.info') do
    its(:content) { should match /name = Chaos tools/ }
  end

  describe file('/var/www/drupal-7.x/sites/all/modules/ctools/.git') do
    specify { should_not be_directory }
  end

  describe file('/var/www/drupal-7.x/sites/all/modules/pathauto/pathauto.admin.inc') do
    its(:content) { should match /module_implements\('pathauto', false, true\);/ }
  end

  describe file('/var/www/drupal-7.x/sites/all/modules/views/views.info') do
    its(:content) { should match /version = "7.x-3.8"/ }
  end

  describe file('/var/www/drupal-7.x/sites/all/themes/omega/omega/omega.info') do
    its(:content) { should match /version = "7.x-4.3"/ }
  end

  describe file('/var/www/drupal-7.x/sites/all/themes/zen/zen.info') do
    its(:content) { should match /version = "7.x-5.5"/ }
  end

  describe file('/var/www/drupal-7.x/sites/all/libraries/jquery_ui/jquery-1.2.6.js') do
    specify { should be_file }
  end
end

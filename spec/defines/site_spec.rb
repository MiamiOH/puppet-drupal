require 'spec_helper'

describe 'drupal::site' do
  let(:title) { 'dummy' }
  let(:make_file) { '/etc/drupal/dummy.make' }

  describe 'with core_version => 6.33' do
    let(:params) { {:core_version => '6.33'} }

    specify { should contain_file(make_file).with_ensure('file') }
    specify { should contain_file(make_file).with_content(/core = 6.x/) }
    specify { should contain_file(make_file).with_content(/projects\[drupal\] = 6\.33/) }
  end

  describe 'with core_version => 7.32' do
    let(:params) { {:core_version => '7.32'} }

    specify { should contain_file(make_file).with_ensure('file') }
    specify { should contain_file(make_file).with_content(/core = 7.x/) }
    specify { should contain_file(make_file).with_content(/projects\[drupal\] = 7\.32/) }
  end

  describe 'with modules view' do
    let(:params) { {:core_version => '7.0', :modules => { 'views' => '3.8' } } }

    specify { should contain_file(make_file).with_content(/projects\[views\] = 3\.8/) }
  end

  describe 'with modules view from custom location' do
    let(:view_module) do
      {
          'type' => 'file',
          'url'  => 'http://example.com/file.zip',
          'md5'  => 'beef'
      }
    end
    let(:params) { {:core_version => '7.0', :modules => { 'views' => view_module } } }

    specify { should contain_file(make_file).with_content(/projects\[views\]\[type\] = module/) }
    specify { should contain_file(make_file).with_content(/projects\[views\]\[download\]\[type\] = file/) }
    specify { should contain_file(make_file).with_content(/projects\[views\]\[download\]\[url\] = http:\/\/example.com\/file.zip/) }
    specify { should contain_file(make_file).with_content(/projects\[views\]\[download\]\[md5\] = beef/) }
  end
end
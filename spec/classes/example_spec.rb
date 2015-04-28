require 'spec_helper'

describe 'icecast' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "icecast class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('icecast::params') }
          it { is_expected.to contain_class('icecast::install').that_comes_before('icecast::config') }
          it { is_expected.to contain_class('icecast::config') }
          it { is_expected.to contain_class('icecast::service').that_subscribes_to('icecast::config') }

          it { is_expected.to contain_service('icecast') }
          it { is_expected.to contain_package('icecast').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'icecast class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('icecast') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end

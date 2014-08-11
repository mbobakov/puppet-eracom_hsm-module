require 'spec_helper'

describe 'eracom_hsm' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "eracom_hsm class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('eracom_hsm::params') }
        it { should contain_class('eracom_hsm::install').that_comes_before('eracom_hsm::config') }
        it { should contain_class('eracom_hsm::config') }
        it { should contain_class('eracom_hsm::service').that_subscribes_to('eracom_hsm::config') }

        it { should contain_service('eracom_hsm') }
        it { should contain_package('eracom_hsm').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'eracom_hsm class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('eracom_hsm') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end

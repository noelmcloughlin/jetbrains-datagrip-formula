# frozen_string_literal: true

title 'datagrip archives profile'

control 'datagrip archive' do
  impact 1.0
  title 'should be installed'

  describe file('/etc/default/datagrip.sh') do
    it { should exist }
  end
  # describe file('/usr/local/jetbrains/datagrip-*/bin/datagrip.sh') do
  #    it { should exist }
  # end
  describe file('/usr/share/applications/datagrip.desktop') do
    it { should exist }
  end
end

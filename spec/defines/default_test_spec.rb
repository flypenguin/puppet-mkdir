require 'spec_helper'

describe 'mkdir::p', :type => :define do
  let(:title) { 'test' }

  context "just a path" do
    let(:title) { '/a/b' }
    it { should contain_exec('mkdir_p_/a/b').with(
      'command' => "mkdir -p '/a/b'"
    ) }
  end

  context "title with path" do
    let(:title) { 'test' }
    let(:params) {{
      :path => '/a/b',
    }}
    it { should contain_exec('mkdir_p_test').with(
      'command' => "mkdir -p '/a/b'"
    ) }
  end

  context "with mode, owner, group" do
    let(:title) { 'test' }
    let(:params) {{
      :path => '/a/b',
      :mode => '0775',
      :owner => 'me',
      :group => 'megroup',
    }}
    it { should contain_exec('mkdir_p_test_chown__me').with(
      'command' => "chown me '/a/b'",
      'unless'  => "test $(stat -c %U '/a/b') = me -o $(stat -c %u '/a/b') = me",
    ) }
    it { should contain_exec('mkdir_p_test_chgrp__megroup').with(
      'command' => "chgrp megroup '/a/b'",
      'unless'  => "test $(stat -c %G '/a/b') = megroup -o $(stat -c %g '/a/b') = megroup",
    ) }
    it { should contain_exec('mkdir_p_test_chmod__0775').with(
      'command' => "chmod 0775 '/a/b'",
      'unless'  => "test $(stat -c %a '/a/b') = 0775 -o $(stat -c %a '/a/b') = 775",
    ) }
  end

  context "with mode, owner, group AND declare_file" do
    let(:title) { 'test' }
    let(:params) {{
      :path => '/a/b',
      :mode => '0775',
      :owner => 'me',
      :group => 'megroup',
      :declare_file => true,
    }}
    it { should_not contain_exec('mkdir_p_test_chown__me') }
    it { should_not contain_exec('mkdir_p_test_chgrp__megroup') }
    it { should_not contain_exec('mkdir_p_test_chmod__0775') }
    it { should contain_file('/a/b').with(
      :ensure => 'directory',
      :mode => '0775',
      :owner => 'me',
      :group => 'megroup',
    ) }
  end

  context "mode specified the wrong way" do
    let(:title) { 'test' }
    let(:params) {{
      :path => '/a/b',
      :mode => '775',
    }}
    it {
      expect { should compile }.to raise_error(/.*4-digit-string.*/)
    }
  end

end

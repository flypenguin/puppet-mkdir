require 'spec_helper'

describe 'mkdir::p' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:title) { 'test' }

      context 'just a path' do
        let(:title) { '/a/b' }

        it {
          is_expected.to contain_exec('mkdir_p_/a/b')
            .with(
              'command' => "mkdir -p '/a/b'",
            )
        }
      end

      context 'title with path' do
        let(:title) { 'test' }
        let(:params) do
          {
            path: '/a/b',
          }
        end

        it {
          is_expected.to contain_exec('mkdir_p_test')
            .with(
              'command' => "mkdir -p '/a/b'",
            )
        }
      end

      context 'with mode, owner, group' do
        let(:title) { 'test' }
        let(:params) do
          {
            path: '/a/b',
            mode: '0775',
            owner: 'me',
            group: 'megroup',
          }
        end

        it {
          is_expected.to contain_exec('mkdir_p_test_chown__me')
            .with(
              'command' => "chown me '/a/b'",
              'unless'  => "test $(stat -c %U '/a/b') = me -o $(stat -c %u '/a/b') = me",
            )
        }
        it {
          is_expected.to contain_exec('mkdir_p_test_chgrp__megroup')
            .with(
              'command' => "chgrp megroup '/a/b'",
              'unless'  => "test $(stat -c %G '/a/b') = megroup -o $(stat -c %g '/a/b') = megroup",
            )
        }
        it {
          is_expected.to contain_exec('mkdir_p_test_chmod__0775')
            .with(
              'command' => "chmod 0775 '/a/b'",
              'unless'  => "test $(stat -c %a '/a/b') = 0775 -o $(stat -c %a '/a/b') = 775",
            )
        }
      end

      context 'with mode, owner, group AND declare_file' do
        let(:title) { 'test' }
        let(:params) do
          {
            path: '/a/b',
            mode: '0775',
            owner: 'me',
            group: 'megroup',
            declare_file: true,
          }
        end

        it {
          is_expected.not_to contain_exec('mkdir_p_test_chown__me')
        }
        it {
          is_expected.not_to contain_exec('mkdir_p_test_chgrp__megroup')
        }
        it {
          is_expected.not_to contain_exec('mkdir_p_test_chmod__0775')
        }
        it {
          is_expected.to contain_file('/a/b')
            .with(
              ensure: 'directory',
              mode: '0775',
              owner: 'me',
              group: 'megroup',
            )
        }
      end
    end
  end
end

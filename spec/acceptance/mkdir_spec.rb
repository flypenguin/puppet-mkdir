require 'spec_helper_acceptance'

describe 'mkdir::p:', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'mkdir is expected to run successfully' do
    pp = "mkdir::p { '/a/b/c': }"

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, catch_failures: true) do |r|
      expect(r.stderr).not_to match(%r{error}i)
    end
    apply_manifest(pp, catch_failures: true) do |r|
      expect(r.stderr).not_to eq(%r{error}i)

      expect(r.exit_code).to be_zero
    end
  end
end

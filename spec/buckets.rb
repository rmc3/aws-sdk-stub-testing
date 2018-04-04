require 'aws-sdk'
require 'rspec'
require_relative '../lib/buckets.rb'


describe 'Buckets' do
  describe '#get_all_bucket_names' do
    def bucket_hashes_to_names(bucket_list)
      bucket_list.map{|bucket| bucket[:name]}
    end

    context 'when we try to get all buckets without stubbing' do
      it 'should raise an error' do
        begin
          Buckets.new.get_all_bucket_names
        rescue => e
          error = e
        else
          error = nil
        end
        expect(error.class).to eq(Aws::Sigv4::Errors::MissingCredentialsError)
      end
    end

    let(:empty_bucket_list_stub) { [] }
    let(:non_empty_bucket_list_stub) { [{name: 'one_bucket'}, {name: 'two_bucket'}] }
    context 'when we try to get all buckets with an empty stub' do
      it 'should return an empty bucket list' do
        stub_bucket_list = []
        Aws.config[:s3] = {
          stub_responses: {
            list_buckets: empty_bucket_list_stub
          }
        }
        expected = bucket_hashes_to_names(empty_bucket_list_stub)
        expect(Buckets.new.get_all_bucket_names).to eq(expected)
      end
    end

    context 'when we try to get all buckets with a stub containing bucket names' do
      it 'should return an empty bucket list' do
        stub_bucket_list = []
        Aws.config[:s3] = {
          stub_responses: {
            list_buckets: { buckets: non_empty_bucket_list_stub }
          }
        }
        expected = bucket_hashes_to_names(non_empty_bucket_list_stub)
        expect(Buckets.new.get_all_bucket_names).to eq(expected)
      end
    end
  end
end

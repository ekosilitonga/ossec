require 'spec_helper'
require 'json'

describe 'ossec::agent' do
  let(:data_bags_path) { File.expand_path('../../../../test/integration/default/data_bags', __FILE__) }
  let(:data_bag_ossec_ssh) { JSON.parse(File.read("#{data_bags_path}/ossec/ssh.json")) }

  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      server.create_data_bag('ossec', {"ssh" => data_bag_ossec_ssh})
    end.converge('ossec::agent')
  end

  it 'includes ossec::client recipe' do
  	expect(chef_run).to include_recipe('ossec::client')
  end
end

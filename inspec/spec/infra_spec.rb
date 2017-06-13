# encoding: utf-8

image_name=ENV['CONT_NAME']
image_ver=ENV['CONT_VER']
cont_name=ENV['CONT_RUN_NAME']

describe docker_image("#{image_name}:#{image_ver}") do
  it { should exist }
  its('repo') { should eq 'quay.io/stefancocora/ngxapp' }
  its('tag') { should eq "#{image_ver}" }
end

describe docker_container("#{cont_name}") do
  it { should exist }
  it { should be_running }
  its('tag') { should eq "#{image_ver}" }
end

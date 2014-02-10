require 'spec_helper_acceptance'

describe "elasticsearch plugin define:" do

  describe "Install a plugin from official repository" do

    it 'should run successfully' do
      pp = "class { 'elasticsearch': config => { 'node.name' => 'elasticearch001' }, manage_repo => true, repo_version => '0.90', java_install => true }
            elasticsearch::plugin{'mobz/elasticsearch-head': module_dir => 'head' }
           "

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    it 'make sure the directory exists' do
      shell('ls /usr/share/elasticsearch/plugins/head/', {:acceptable_exit_codes => 0})
    end

    it 'make sure elasticsearch reports it as existing' do
      sleep 10
      shell("/usr/bin/curl http://localhost:9200/_nodes/?plugin | grep head", {:acceptable_exit_codes => 0})
    end

  end

  describe "Install a plugin from custom git repo" do

    it 'should run successfully' do
      pp = "class { 'elasticsearch': config => { 'node.name' => 'elasticearch001' }, manage_repo => true, repo_version => '0.90', java_install => true }
            elasticsearch::plugin{ 'elasticsearch-jetty':  module_dir => 'jetty', url => 'https://oss-es-plugins.s3.amazonaws.com/elasticsearch-jetty/elasticsearch-jetty-0.90.0.zip' }
           "

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    it 'make sure the directory exists' do
      shell('ls /usr/share/elasticsearch/plugins/jetty/', {:acceptable_exit_codes => 0})
    end

    it 'make sure elasticsearch reports it as existing' do
      sleep 10
      shell("/usr/bin/curl http://localhost:9200/_nodes/?plugin | grep jetty", {:acceptable_exit_codes => 0})
    end

  end

  #describe "Install a non existing plugin" do
#
#    it 'should run successfully' do
#      pp = "class { 'elasticsearch': config => { 'node.name' => 'elasticearch001' }, manage_repo => true, repo_version => '0.90', java_install => true }
#          elasticsearch::template { 'foo': ensure => 'present', file => 'puppet:///modules/another/good.json' }"
#
#      # Run it twice and test for idempotency
#      apply_manifest(pp, :catch_failures => true)
#      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
#    end
#
#  end


end


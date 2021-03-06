require 'spec_helper'

describe Gordon::EnvVars do
  let(:attributes) do
    {
      app_type:             "web",
      app_name:             "xirubiru",
      app_description:      "a nice description",
      app_homepage:         "http://some.github.repo",
      app_version:          "2.0.0",
      app_source:           ".",
      app_source_excludes:  %w(one two three),
      runtime_name:         "ruby",
      runtime_version:      "2.2.0",
      http_server_type:     "nginx",
      web_server_type:      "tomcat",
      init_type:            "systemd",
    }
  end

  let(:options) { double(Gordon::Options, attributes) }

  describe 'getting from cook options' do
    it 'returns a array of environment variables setted' do
      expected = [
        "GORDON_APP_TYPE='#{options.app_type}'",
        "GORDON_APP_NAME='#{options.app_name}'",
        "GORDON_APP_DESCRIPTION='#{options.app_description}'",
        "GORDON_APP_HOMEPAGE='#{options.app_homepage}'",
        "GORDON_APP_VERSION='#{options.app_version}'",
        "GORDON_APP_SOURCE='#{File.expand_path(options.app_source)}'",
        "GORDON_APP_SOURCE_EXCLUDES='#{options.app_source_excludes.join(",") }'",
        "GORDON_RUNTIME_NAME='#{options.runtime_name}'",
        "GORDON_RUNTIME_VERSION='#{options.runtime_version}'",
        "GORDON_HTTP_SERVER_TYPE='#{options.http_server_type}'",
        "GORDON_WEB_SERVER_TYPE='#{options.web_server_type}'",
        "GORDON_INIT_TYPE='#{options.init_type}'",
      ]

      expect(described_class.from_cook(options)).to eq(expected)
    end
  end

  describe 'loading from environment' do
    it 'returns a instance with all specified values' do
      env = {
        'GORDON_APP_TYPE'             => options.app_type,
        'GORDON_APP_NAME'             => options.app_name,
        'GORDON_APP_DESCRIPTION'      => options.app_description,
        'GORDON_APP_HOMEPAGE'         => options.app_homepage,
        'GORDON_APP_VERSION'          => options.app_version,
        'GORDON_APP_SOURCE'           => options.app_source,
        'GORDON_APP_SOURCE_EXCLUDES'  => options.app_source_excludes.join(","),
        'GORDON_RUNTIME_NAME'         => options.runtime_name,
        'GORDON_RUNTIME_VERSION'      => options.runtime_version,
        'GORDON_HTTP_SERVER_TYPE'     => options.http_server_type,
        'GORDON_WEB_SERVER_TYPE'      => options.web_server_type,
        'GORDON_INIT_TYPE'            => options.init_type,
      }

      env.each_pair { |k, v| expect(ENV).to receive(:[]).with(k).and_return(v.to_s) }

      described_class.load.tap do |env_vars|
        env.each_pair do |k, v|
          expected = k == 'GORDON_APP_SOURCE_EXCLUDES' ? options.app_source_excludes : v.to_s

          expect(env_vars.send(k.gsub(/GORDON_/, '').downcase)).to eq(expected)
        end
      end
    end
  end
end


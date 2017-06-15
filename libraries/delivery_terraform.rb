#
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/mixin/shell_out'
require_relative './delivery_dsl'
require 'chef/dsl'

module DeliverySugar
  #
  # This class is our interface to execute terraform in Delivery
  #
  class TerraForm
    include Chef::DSL::Recipe
    include DeliverySugar::DSL
    include Chef::Mixin::ShellOut
    attr_reader :plan_dir, :repo_path

    #
    # Create a new TerraForm object
    #
    # @param plan_dir [String]
    #   The path to the directory containing the *.tf files
    # @param repo_path [String]
    #   The path to the project repository within the workspace
    # @param run_context [Chef::RunContext]
    #   The object that loads and tracks the context of the Chef run
    # @return [DeliverySugar::TerraForm]
    #
    def initialize(plan_dir, repo_path, run_context, parameters = {})
      @plan_dir = plan_dir
      @repo_path = repo_path
      @run_context = run_context
      @options = parameters[:options] || ''
    end

    #
    # Run terraform action
    #
    # rubocop:disable Metrics/MethodLength
    def run(action)
      cmd = case action
            when 'init', 'plan', 'apply'
              "terraform #{action} -lock=false #{@plan_dir}"
            when 'destroy'
              "terraform #{action} -lock=false --force #{@plan_dir}"
            when 'show'
              "terraform #{action}"
            end
      begin
        shell_out!(
          cmd,
          cwd: @repo_path,
          live_stream: STDOUT
        )
      rescue Mixlib::ShellOut::ShellCommandFailed,
             Mixlib::ShellOut::CommandTimeout => ex
        Chef::Log.error("Caught Exception: #{ex}")
        shell_out!(
          "terraform destroy -lock=false --force #{@plan_dir}",
          cwd: @repo_path,
          live_stream: STDOUT
        )
        raise
      end
    end

    private

    # Returns the Chef::Node Object coming from the run_context
    def node
      run_context && run_context.node
    end

    # Used by providers supporting embedded recipes
    def resource_collection
      run_context && run_context.resource_collection
    end
  end
end

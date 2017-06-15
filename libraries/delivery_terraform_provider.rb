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

require 'chef/provider'

class Chef
  class Provider
    class DeliveryTerraForm < Chef::Provider
      attr_reader :terraform

      def whyrun_supported?
        true
      end

      def load_current_resource
        # There is no existing resource to evaluate, but we are required
        # to override it.
      end

      def initialize(new_resource, run_context)
        super

        @terraform = DeliverySugar::TerraForm.new(
          new_resource.plan_dir,
          new_resource.repo_path,
          run_context
        )
      end

      def action_init
        tf('init')
      end

      def action_plan
        tf('plan')
      end

      def action_apply
        tf('apply')
      end

      def action_show
        tf('show')
      end

      def action_destroy
        tf('destroy')
      end

      def action_test
        tf('init')
        tf('plan')
        tf('apply')
        tf('show')
        tf('destroy')
      end

      private

      def tf(action)
        converge_by "[Terraform]  Run action :#{action} " \
          "with *.tf files in #{new_resource.plan_dir}\n" do
          @terraform.run(action)
          new_resource.updated_by_last_action(true)
        end
      end
    end
  end
end

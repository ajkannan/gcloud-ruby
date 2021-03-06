# Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "helper"

describe Gcloud::Pubsub::Subscription, :name, :mock_pubsub do
  let(:topic_name) { "topic-name-goes-here" }
  let(:sub_name) { "subscription-name-goes-here" }
  let(:sub_path) { subscription_path sub_name }
  let(:sub_json) { subscription_json topic_name, sub_name }
  let :subscription do
    json = JSON.parse(sub_json)
    Gcloud::Pubsub::Subscription.from_gapi json, pubsub.connection
  end

  it "gives the name returned from the HTTP method" do
    subscription.name.must_equal sub_path
  end

  describe "lazy subscription given the short name" do
    let :subscription do
      Gcloud::Pubsub::Subscription.new_lazy sub_name,
                                            pubsub.connection
    end

    it "matches the name returned from the HTTP method" do
      subscription.name.must_equal sub_path
    end
  end

  describe "lazy subscription object given the full path" do
    let :subscription do
      Gcloud::Pubsub::Subscription.new_lazy sub_path,
                                            pubsub.connection
    end

    it "matches the name returned from the HTTP method" do
      subscription.name.must_equal sub_path
    end
  end
end

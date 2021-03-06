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

describe Gcloud::Pubsub::Subscription, :pull, :wait, :mock_pubsub do
  let(:topic_name) { "topic-name-goes-here" }
  let(:sub_name) { "subscription-name-goes-here" }
  let(:sub_json) { subscription_json topic_name, sub_name }
  let(:sub_hash) { JSON.parse sub_json }
  let :subscription do
    Gcloud::Pubsub::Subscription.from_gapi sub_hash, pubsub.connection
  end

  it "can pull messages without returning immediately" do
    rec_message_msg = "pulled-message"
    mock_connection.post "/v1/projects/#{project}/subscriptions/#{sub_name}:pull" do |env|
      # We could sleep here, but, really, why?
      JSON.parse(env.body)["returnImmediately"].must_equal false
      [200, {"Content-Type"=>"application/json"},
       rec_messages_json(rec_message_msg)]
    end

    rec_messages = subscription.pull immediate: false
    rec_messages.wont_be :empty?
    rec_messages.first.message.data.must_equal rec_message_msg
  end

  it "can pull messages by calling wait_for_messages" do
    rec_message_msg = "pulled-message"
    mock_connection.post "/v1/projects/#{project}/subscriptions/#{sub_name}:pull" do |env|
      # We could sleep here, but, really, why?
      JSON.parse(env.body)["returnImmediately"].must_equal false
      [200, {"Content-Type"=>"application/json"},
       rec_messages_json(rec_message_msg)]
    end

    rec_messages = subscription.wait_for_messages
    rec_messages.wont_be :empty?
    rec_messages.first.message.data.must_equal rec_message_msg
  end

  it "will not error when a request times out with Faraday::TimeoutError" do
    mock_connection.post "/v1/projects/#{project}/subscriptions/#{sub_name}:pull" do |env|
      # simulate a timed out HTTP request
      raise Faraday::TimeoutError
    end

    rec_messages = subscription.pull immediate: false
    rec_messages.must_be :empty?
  end
end

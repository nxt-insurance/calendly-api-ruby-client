# frozen_string_literal: true

require 'test_helper'

module Calendly
  # test for Calendly::WebhookSubscription
  class WebhookSubscriptionTest < BaseTest
    def setup
      super
      @webhook_uuid = 'ORG_WEBHOOK001'
      @webhook_uri = "#{HOST}/webhook_subscriptions/#{@webhook_uuid}"
      attrs = {uri: @webhook_uri}
      @webhook = WebhookSubscription.new attrs, @client
      @webhook_no_client = WebhookSubscription.new attrs
    end

    def test_it_returns_inspect_string
      assert @webhook.inspect.start_with? '#<Calendly::WebhookSubscription:'
    end

    def test_that_it_returns_an_error_client_is_not_ready
      proc_client_is_blank = proc do
        @webhook_no_client.fetch
      end
      assert_error proc_client_is_blank, '@client is not ready.'
    end

    def test_that_it_returns_an_associated_webhook
      res_body = load_test_data 'webhook_organization_001.json'
      add_stub_request :get, @webhook_uri, res_body: res_body
      assert_org_webhook_001 @webhook.fetch
    end

    def test_that_it_deletes_self
      add_stub_request :delete, @webhook_uri, res_status: 204
      result = @webhook.delete
      assert_equal true, result
    end
  end
end

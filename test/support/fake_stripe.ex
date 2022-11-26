defmodule StripeCart.Test.FakeStripe do
  def populate_cache() do
    product = %{
      amount: 1100,
      id: "price_123",
      product: %Stripe.Product{
        active: true,
        attributes: [],
        caption: nil,
        created: 1_664_649_973,
        deactivate_on: nil,
        default_price: "price_1LoAhVKFGxMzGbgkUgrHPg0z",
        deleted: nil,
        description: "Awww cuuute wah wah wah babies",
        id: "price_123",
        images: [
          "https://files.stripe.com/links/MDB8YWNjdF8xSTQ2a3FLRkd4TXpHYmdrfGZsX3Rlc3Rfa2psMk5KcERPelRWeGp3OVpDT1oxcXhE004CuzJnnL"
        ],
        livemode: false,
        metadata: %{},
        name: "Nifty onesie",
        object: "product",
        package_dimensions: nil,
        shippable: nil,
        statement_descriptor: nil,
        type: "service",
        unit_label: nil,
        updated: 1_664_649_974,
        url: nil
      }
    }

    product2 = %{
      amount: 1000,
      id: "price_456",
      product: %Stripe.Product{
        active: true,
        attributes: [],
        caption: nil,
        created: 1_664_649_973,
        deactivate_on: nil,
        default_price: "price_1LoAhVKFGxMzGbgkUgrHPg0z",
        deleted: nil,
        description: "Put liquid in it. Or don't its up to you",
        id: "prod_456",
        images: [
          "https://files.stripe.com/links/MDB8YWNjdF8xSTQ2a3FLRkd4TXpHYmdrfGZsX3Rlc3Rfa2psMk5KcERPelRWeGp3OVpDT1oxcXhE004CuzJnnL"
        ],
        livemode: false,
        metadata: %{},
        name: "Groovy cup",
        object: "product",
        package_dimensions: nil,
        shippable: nil,
        statement_descriptor: nil,
        type: "service",
        unit_label: nil,
        updated: 1_664_649_974,
        url: nil
      }
    }

    Cachex.put!(:stripe_products, "price_123", product)
    Cachex.put!(:stripe_products, "price_456", product2)
    [product, product2]
  end

  def create_checkout_session(%{
        mode: "payment",
        cancel_url: cancel_url,
        success_url: success_url,
        line_items: _line_items
      }) do
    {:ok,
     %Stripe.Session{
       id: "cs_test_a1iJRREh0dhvx6feR1F3Z8zQ0bkAbmkrIP6kdY2WsV6Yoa5pcS14JeCwsv",
       object: "checkout.session",
       after_expiration: nil,
       allow_promotion_codes: nil,
       amount_subtotal: 1100,
       amount_total: 1100,
       automatic_tax: %{enabled: false, status: nil},
       billing_address_collection: nil,
       cancel_url: cancel_url,
       client_reference_id: nil,
       consent: nil,
       consent_collection: nil,
       currency: "usd",
       customer: nil,
       customer_creation: "always",
       customer_details: nil,
       customer_email: nil,
       line_items: nil,
       expires_at: 1_666_034_241,
       livemode: false,
       locale: nil,
       metadata: %{},
       mode: "payment",
       payment_intent: "pi_3LtcKrKFGxMzGbgk1MJnEgQ8",
       payment_link: nil,
       payment_method_options: %{},
       payment_method_types: ["card"],
       payment_status: "unpaid",
       phone_number_collection: %{enabled: false},
       recovered_from: nil,
       setup_intent: nil,
       shipping: nil,
       shipping_address_collection: nil,
       shipping_options: [],
       shipping_rate: nil,
       status: "open",
       submit_type: nil,
       subscription: nil,
       success_url: success_url,
       tax_id_collection: nil,
       total_details: %{amount_discount: 0, amount_shipping: 0, amount_tax: 0},
       url:
         "https://checkout.stripe.com/c/pay/cs_test_a1iJRREh0dhvx6feR1F3Z8zQ0bkAbmkrIP6kdY2WsV6Yoa5pcS14JeCwsv#fidkdWxOYHwnPyd1blpxYHZxWjA0TDEzbnROQ0J9SH9CZ2JuZ04zck0yPFFzfE5cdWxyNFJgXXdscjNoZndwa1M1TFV9bn9ocl9vNGdURDZKQER3Y2tMPWZAUUtxV0dhMWc2SlZ0bGBLQzR%2FNTVEf05NU1dpSicpJ2N3amhWYHdzYHcnP3F3cGApJ2lkfGpwcVF8dWAnPyd2bGtiaWBabHFgaCcpJ2BrZGdpYFVpZGZgbWppYWB3dic%2FcXdwYHgl"
     }}
  end

  def token("ac_valid") do
    {:ok,
     %{
       access_token:
         "sk_test_51Lww00KVDRvT3Ge7HBTmoq8NbFSI8rPp0c1JMweDz4W7v4ii8zyBeODm9Njazv031Tz6voVH4w4GiTrbZtXJ14IR001rPg0ZIN",
       livemode: false,
       refresh_token: "rt_MsExTuO5ggd8MVXc4FJNi3ptHNOi9t1q5ADcJY8Ef1e0N124",
       scope: "read_write",
       stripe_publishable_key:
         "pk_test_51Lww00KVDRvT3Ge7pdmZLtmucLUMXshPfw0Kc0cvRk7FFkRlgluulLzf1mdbSgFy7J0hPhY0MbbnxvQNI4AbMHN800WIvrCjWA",
       stripe_user_id: "acct_1Lww00KVDRvT3Ge7",
       token_type: "bearer"
     }}
  end

  def token(_token) do
    {:error,
     %Stripe.Error{
       source: :stripe,
       code: :bad_request,
       request_id: {"Request-Id", "req_2zKIiraZJgjDJi"},
       extra: %{http_status: 400},
       message: "The request was unacceptable, often due to missing a required parameter.",
       user_message: nil
     }}
  end
end

defmodule LaunchCart.Test.FakeLaunch do
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

  def create_checkout_session(
        %{
          mode: "payment",
          cancel_url: cancel_url,
          success_url: success_url,
          line_items: _line_items
        },
        connect_account: "acc_valid_account"
      ) do
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

  def get_stripe_account("acc_id_only") do
    {:ok, %Stripe.Account{id: "acct_1Lww2pKjsAoFfhR4"}}
  end

  def get_stripe_account("acc_dashboard_settings") do
    {:ok,
     %Stripe.Account{
       id: "acct_1Lww2pKjsAoFfhR4",
       object: "account",
       business_profile: nil,
       business_type: nil,
       charges_enabled: true,
       settings: %{
         bacs_debit_payments: %{},
         branding: %{icon: nil, logo: nil, primary_color: nil, secondary_color: nil},
         card_issuing: %{tos_acceptance: %{date: nil, ip: nil}},
         card_payments: %{
           statement_descriptor_prefix: "BLOOF",
           statement_descriptor_prefix_kana: nil,
           statement_descriptor_prefix_kanji: nil
         },
         dashboard: %{
           display_name: "SuperMegaFoobarCorp!",
           timezone: "America/New_York"
         },
         payments: %{
           statement_descriptor: "BLOOF",
           statement_descriptor_kana: nil,
           statement_descriptor_kanji: nil
         },
         sepa_debit_payments: %{}
       },
       country: "US",
       default_currency: "usd",
       details_submitted: false
     }}
  end

  def get_stripe_account(_id) do
    {:ok,
     %Stripe.Account{
       id: "acct_1Lww2pKjsAoFfhR4",
       object: "account",
       business_profile: %{
         mcc: "5734",
         name: "Lunch Scout",
         support_address: %{
           city: "Cincinnati",
           country: "US",
           line1: "641 Evangeline Road",
           line2: nil,
           postal_code: "45240",
           state: "OH"
         },
         support_email: nil,
         support_phone: "+15134705318",
         support_url: nil,
         url: "https://launchscout.com"
       },
       business_type: nil,
       capabilities: %{
         acss_debit_payments: "inactive",
         affirm_payments: "inactive",
         afterpay_clearpay_payments: "inactive",
         bancontact_payments: "inactive",
         card_payments: "inactive",
         eps_payments: "inactive",
         giropay_payments: "inactive",
         ideal_payments: "inactive",
         link_payments: "inactive",
         p24_payments: "inactive",
         sepa_debit_payments: "inactive",
         sofort_payments: "inactive",
         transfers: "inactive",
         us_bank_account_ach_payments: "inactive"
       },
       charges_enabled: false,
       company: nil,
       controller: %{is_controller: true, type: "application"},
       country: "US",
       created: 1_666_739_353,
       default_currency: "usd",
       deleted: nil,
       details_submitted: true,
       email: "superchrisnelson@gmail.com",
       external_accounts: %Stripe.List{
         object: "list",
         data: [
           %Stripe.BankAccount{
             id: "ba_1Lww7LKjsAoFfhR4eHVgaXE2",
             object: "bank_account",
             account: "acct_1Lww2pKjsAoFfhR4",
             account_holder_name: nil,
             account_holder_type: nil,
             available_payout_methods: ["standard"],
             bank_name: "STRIPE TEST BANK",
             country: "US",
             currency: "usd",
             customer: nil,
             default_for_currency: true,
             deleted: nil,
             fingerprint: "chCBVOWckAXnsDWr",
             last4: "6789",
             metadata: %{},
             routing_number: "110000000",
             status: "new"
           }
         ],
         has_more: false,
         total_count: 1,
         url: "/v1/accounts/acct_1Lww2pKjsAoFfhR4/external_accounts"
       },
       future_requirements: %{
         alternatives: [],
         current_deadline: nil,
         currently_due: [],
         disabled_reason: nil,
         errors: [],
         eventually_due: [],
         past_due: [],
         pending_verification: []
       },
       individual: nil,
       metadata: %{},
       payouts_enabled: false,
       requirements: %{
         alternatives: [],
         current_deadline: nil,
         currently_due: ["individual.id_number"],
         disabled_reason: "requirements.past_due",
         errors: [],
         eventually_due: ["individual.id_number"],
         past_due: ["individual.id_number"],
         pending_verification: []
       },
       settings: %{
         bacs_debit_payments: %{},
         branding: %{icon: nil, logo: nil, primary_color: nil, secondary_color: nil},
         card_issuing: %{tos_acceptance: %{date: nil, ip: nil}},
         card_payments: %{
           decline_on: %{avs_failure: true, cvc_failure: true},
           statement_descriptor_prefix: "LC CART",
           statement_descriptor_prefix_kana: nil,
           statement_descriptor_prefix_kanji: nil
         },
         dashboard: %{display_name: "Launchscout", timezone: "Etc/UTC"},
         payments: %{
           statement_descriptor: "LAUNCH SCOUT CART",
           statement_descriptor_kana: nil,
           statement_descriptor_kanji: nil
         },
         payouts: %{
           debit_negative_balances: true,
           schedule: %{delay_days: 2, interval: "daily"},
           statement_descriptor: nil
         },
         sepa_debit_payments: %{}
       },
       tos_acceptance: %{date: 1_666_738_980},
       type: "standard"
     }}
  end

  def list_products(_params, connect_account: "acc_valid_account") do
    {:ok,
     %Stripe.List{
       object: "list",
       data: [
         %Stripe.Product{
           id: "prod_123",
           object: "product",
           active: true,
           attributes: [],
           caption: nil,
           created: 1_664_649_973,
           deactivate_on: nil,
           default_price: "price_123",
           deleted: nil,
           description: "Awww cuuute wah wah wah babies",
           images: [
             "https://files.stripe.com/links/MDB8YWNjdF8xSTQ2a3FLRkd4TXpHYmdrfGZsX3Rlc3Rfa2psMk5KcERPelRWeGp3OVpDT1oxcXhE004CuzJnnL"
           ],
           livemode: false,
           metadata: %{"size" => "blue"},
           name: "Nifty onesie",
           package_dimensions: nil,
           shippable: nil,
           statement_descriptor: nil,
           type: "service",
           unit_label: nil,
           updated: 1_666_718_255,
           url: nil
         },
         %Stripe.Product{
           id: "prod_345",
           object: "product",
           active: true,
           attributes: [],
           caption: nil,
           created: 1_664_648_447,
           deactivate_on: nil,
           default_price: "price_1LoAItKFGxMzGbgkER0DuC94",
           deleted: nil,
           description: "There's a lid and stuff.",
           images: [
             "https://files.stripe.com/links/MDB8YWNjdF8xSTQ2a3FLRkd4TXpHYmdrfGZsX3Rlc3RfUVdWbGlCdlJxMGdFclFWWEVySUcwWHlB00iYAtmJMM"
           ],
           livemode: false,
           metadata: %{},
           name: "Happy mug",
           package_dimensions: nil,
           shippable: nil,
           statement_descriptor: nil,
           type: "service",
           unit_label: nil,
           updated: 1_667_923_666,
           url: nil
         },
         %Stripe.Product{
           id: "pins",
           object: "product",
           active: true,
           attributes: ["set"],
           caption: nil,
           created: 1_609_344_091,
           deactivate_on: [],
           default_price: nil,
           deleted: nil,
           description: nil,
           images: [],
           livemode: false,
           metadata: %{},
           name: "Launch Pins",
           package_dimensions: nil,
           shippable: true,
           statement_descriptor: nil,
           type: "good",
           unit_label: nil,
           updated: 1_609_344_091,
           url: nil
         },
         %Stripe.Product{
           id: "increment",
           object: "product",
           active: true,
           attributes: ["issue"],
           caption: nil,
           created: 1_609_344_091,
           deactivate_on: [],
           default_price: nil,
           deleted: nil,
           description: nil,
           images: [],
           livemode: false,
           metadata: %{},
           name: "Increment Magazine",
           package_dimensions: nil,
           shippable: true,
           statement_descriptor: nil,
           type: "good",
           unit_label: nil,
           updated: 1_609_344_091,
           url: nil
         },
         %Stripe.Product{
           id: "shirt",
           object: "product",
           active: true,
           attributes: ["size", "gender"],
           caption: nil,
           created: 1_609_344_091,
           deactivate_on: [],
           default_price: nil,
           deleted: nil,
           description: nil,
           images: [],
           livemode: false,
           metadata: %{},
           name: "Launch Shirt",
           package_dimensions: nil,
           shippable: true,
           statement_descriptor: nil,
           type: "good",
           unit_label: nil,
           updated: 1_609_344_091,
           url: nil
         }
       ],
       has_more: false,
       total_count: nil,
       url: "/v1/products"
     }}
  end

  def list_products(_, _) do
    {:error,
     %Stripe.Error{
       source: :stripe,
       code: :invalid_request_error,
       request_id: nil,
       extra: %{
         card_code: :account_invalid,
         http_status: 403,
         raw_error: %{
           "code" => "account_invalid",
           "doc_url" => "https://stripe.com/docs/error-codes/account-invalid",
           "message" =>
             "The provided key 'sk_test_*********************************************************************************************CGdW2x' does not have access to account 'garbage' (or that account does not exist). Application access may have been revoked.",
           "type" => "invalid_request_error"
         }
       },
       message:
         "The provided key 'sk_test_*********************************************************************************************CGdW2x' does not have access to account 'garbage' (or that account does not exist). Application access may have been revoked.",
       user_message: nil
     }}
  end

  def list_prices(_params, connect_account: "acc_valid_account") do
    {:ok,
     %Stripe.List{
       object: "list",
       data: [
         %Stripe.Price{
           id: "price_123",
           object: "price",
           active: true,
           billing_scheme: "per_unit",
           created: 1_664_649_973,
           currency: "usd",
           livemode: false,
           lookup_key: nil,
           metadata: %{},
           nickname: nil,
           product: "prod_123",
           recurring: nil,
           tax_behavior: "exclusive",
           tiers: nil,
           tiers_mode: nil,
           transform_lookup_key: nil,
           transform_quantity: nil,
           type: "one_time",
           unit_amount: 1100,
           unit_amount_decimal: "1100"
         },
         %Stripe.Price{
           id: "price_345",
           object: "price",
           active: true,
           billing_scheme: "per_unit",
           created: 1_664_648_447,
           currency: "usd",
           livemode: false,
           lookup_key: nil,
           metadata: %{},
           nickname: nil,
           product: "prod_345",
           recurring: nil,
           tax_behavior: "exclusive",
           tiers: nil,
           tiers_mode: nil,
           transform_lookup_key: nil,
           transform_quantity: nil,
           type: "one_time",
           unit_amount: 1100,
           unit_amount_decimal: "1100"
         }
       ],
       has_more: false,
       total_count: nil,
       url: "/v1/prices"
     }}
  end

  def list_prices(_, _) do
    {:error,
     %Stripe.Error{
       source: :stripe,
       code: :invalid_request_error,
       request_id: nil,
       extra: %{
         card_code: :account_invalid,
         http_status: 403,
         raw_error: %{
           "code" => "account_invalid",
           "doc_url" => "https://stripe.com/docs/error-codes/account-invalid",
           "message" =>
             "The provided key 'sk_test_*********************************************************************************************CGdW2x' does not have access to account 'garbage' (or that account does not exist). Application access may have been revoked.",
           "type" => "invalid_request_error"
         }
       },
       message:
         "The provided key 'sk_test_*********************************************************************************************CGdW2x' does not have access to account 'garbage' (or that account does not exist). Application access may have been revoked.",
       user_message: nil
     }}
  end

  def get_session("sess_expired", connect_account: _account) do
    {:ok, %Stripe.Session{status: "expired"}}
  end

  def get_session("sess_nil_status", connect_account: _account) do
    {:ok, %Stripe.Session{status: nil}}
  end

  def get_session("sess_complete", connect_account: _account) do
    {:ok,
     %Stripe.Session{
       id: "cs_test_b1ktEfe4UAFQzlx7WK5z1sALwSy8rC50J0TXUS4uZUhhogzTRmEUSQ3i6S",
       object: "checkout.session",
       after_expiration: nil,
       allow_promotion_codes: nil,
       amount_subtotal: 5700,
       amount_total: 5700,
       automatic_tax: %{enabled: false, status: nil},
       billing_address_collection: nil,
       cancel_url: "http://localhost:8080/shop/",
       client_reference_id: nil,
       consent: nil,
       consent_collection: nil,
       currency: "usd",
       customer: "cus_Mu8e7lJaDyNtXa",
       customer_creation: "always",
       customer_details: %{
         address: %{
           city: "Cincinnati",
           country: "US",
           line1: "641 Evangeline Rd",
           line2: nil,
           postal_code: "45240",
           state: "OH"
         },
         email: "superchrisnelson@gmail.com",
         name: "Chris Nelson",
         phone: nil,
         tax_exempt: "none",
         tax_ids: []
       },
       customer_email: nil,
       line_items: nil,
       expires_at: 1_670_016_750,
       livemode: false,
       locale: nil,
       metadata: %{},
       mode: "payment",
       payment_intent: "pi_3MAKMsGpfulOf84Y1NW9Id6O",
       payment_link: nil,
       payment_method_options: %{},
       payment_method_types: ["card"],
       payment_status: "paid",
       phone_number_collection: %{enabled: false},
       recovered_from: nil,
       setup_intent: nil,
       shipping: %{
         address: %{
           city: "Cincinnati",
           country: "US",
           line1: "641 Evangeline Rd",
           line2: nil,
           postal_code: "45240",
           state: "OH"
         },
         name: "Christopher C Nelson"
       },
       shipping_address_collection: %{allowed_countries: ["US"]},
       shipping_options: [],
       shipping_rate: nil,
       status: "complete",
       submit_type: nil,
       subscription: nil,
       success_url: "http://localhost:8080/shop/",
       tax_id_collection: nil,
       total_details: %{amount_discount: 0, amount_shipping: 0, amount_tax: 0},
       url: nil
     }}
  end

  def get_price("price_789", connect_account: "acc_valid_account", expand: ["product"]) do
    {:ok,
     %Stripe.Price{
       id: "price_789",
       object: "price",
       active: true,
       billing_scheme: "per_unit",
       created: 1_675_448_075,
       currency: "usd",
       livemode: false,
       lookup_key: nil,
       metadata: %{},
       nickname: nil,
       product: %Stripe.Product{
         id: "prod_NI3uWJAbmr03eA",
         object: "product",
         active: true,
         attributes: [],
         caption: nil,
         created: 1_675_448_074,
         deactivate_on: nil,
         default_price: "price_1MXTmRCOWcOFl6axhVFX7Bab",
         deleted: nil,
         description: "Can't believe My New House",
         images: [
           "https://files.stripe.com/links/MDB8YWNjdF8xTVZKdXNDT1djT0ZsNmF4fGZsX3Rlc3RfSkxhTmR6S0U2ZThob0VRbDJlRTBLdWdv00q6tLiBlW"
         ],
         livemode: false,
         metadata: %{},
         name: "My New House",
         package_dimensions: nil,
         shippable: nil,
         statement_descriptor: nil,
         type: "service",
         unit_label: nil,
         updated: 1_675_539_096,
         url: nil
       },
       recurring: nil,
       tax_behavior: "unspecified",
       tiers: nil,
       tiers_mode: nil,
       transform_lookup_key: nil,
       transform_quantity: nil,
       type: "one_time",
       unit_amount: 10_000_000,
       unit_amount_decimal: "10000000"
     }}
  end

  def get_price(_, connect_account: "acc_valid_account", expand: ["product"]) do
    {:error,
     %Stripe.Error{
       source: :stripe,
       code: :invalid_request_error,
       request_id: {"Request-Id", "req_x7PiwYlt9Kt1cn"},
       extra: %{
         card_code: :resource_missing,
         http_status: 404,
         param: :price,
         raw_error: %{
           "code" => "resource_missing",
           "doc_url" => "https://stripe.com/docs/error-codes/resource-missing",
           "message" => "No such price: 'price_garbage'",
           "param" => "price",
           "request_log_url" =>
             "https://dashboard.stripe.com/acct_1MVJusCOWcOFl6ax/test/logs/req_x7PiwYlt9Kt1cn?t=1678734859",
           "type" => "invalid_request_error"
         }
       },
       message: "No such price: 'price_garbage'",
       user_message: nil
     }}
  end
end

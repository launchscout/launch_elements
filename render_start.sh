#!/bin/bash

_build/prod/rel/stripe_cart/bin/stripe_cart eval "StripeCart.ReleaseTasks.migrate()"
_build/prod/rel/stripe_cart/bin/stripe_cart start
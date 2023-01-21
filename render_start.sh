#!/bin/bash

_build/prod/rel/launch_cart/bin/launch_cart eval "LaunchCart.ReleaseTasks.migrate()"
_build/prod/rel/launch_cart/bin/launch_cart start
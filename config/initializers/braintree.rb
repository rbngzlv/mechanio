Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "6vhxxkp32z28zgp5"
Braintree::Configuration.public_key = "xsnkb8dmqmfrfb4r"
Braintree::Configuration.private_key = "160beebf023a1ca963715e93c7081789"

Braintree::Configuration.logger = Logger.new("/dev/null") if Rails.env.test?

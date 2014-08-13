# == Class eracom_hsm::key
#
class eracom_hsm::key {
#TODO: using parser-future and using lambdas

# Define: keys
    define keys () {
      $key=$name
      # notify { $key :
      #   message => $eracom_hsm::keys[$key],
      # }
    }
    $keys_of_keys = keys($eracom_hsm::keys)
    keys { $keys_of_keys : }

}
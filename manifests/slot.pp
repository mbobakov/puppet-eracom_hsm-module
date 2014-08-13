# == Class eracom_hsm::slot
#
class eracom_hsm::slot {
  #TODO: using parser-future and using lambdas
  # Define: slots
  define slots () {
    $slot=$name
    slot { $slot :
      ensure    => present,
      user_pin  => $eracom_hsm::slots[$slot]['user_pin'],
      admin_pin => $eracom_hsm::admin_pin,
    }

  }

  $keys_of_slots = keys($eracom_hsm::slots)
  slots { $keys_of_slots : }
}
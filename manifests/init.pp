# == Class: eracom_hsm
#
# Full description of class eracom_hsm here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class eracom_hsm (
  $mode         = $eracom_hsm::params::mode,
  $store        = undef,
  $os_users     = 'root',
  $package_src  = $eracom_hsm::params::package_src,
  $so_pin       = $eracom_hsm::params::so_pin,
  $num_of_slots = $eracom_hsm::params::num_of_slots,
  $keys         = hiera(eracom_hsm::keys, { 'SAMPLE' => {'name'=>'SAMPLE', 'attributes' =>['A', 'B', 'C'], 'slot' => 1} } ), #TO-DO replace this dirty-hack

) inherits eracom_hsm::params {

  # validate parameters here

  class { 'eracom_hsm::install': } ->
  class { 'eracom_hsm::config': } ->
  Class['eracom_hsm']
}

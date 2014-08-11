# == Class eracom_hsm::params
#
# This class is meant to be called from eracom_hsm
# It sets variables according to platform
#
class eracom_hsm::params {
    #CHECK OS. Now Eracom-libs support Redhat-like OS.
    if $::osfamily != 'RedHat' {
        fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
}


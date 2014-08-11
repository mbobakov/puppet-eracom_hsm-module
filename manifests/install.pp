# == Class eracom_hsm::install
#
class eracom_hsm::install {

    if $::architecture == 'x86_64' {
        $package_arch='64'
    } else {
        $package_arch=''
    }

    if $eracom_hsm::mode == 'emulator' {
        package { 'ETcpsdk':
        ensure        => installed,
        allow_virtual => false,
        provider      => rpm,
        source        => "${eracom_hsm::package_src}/Ptk-C/Linux${package_arch}/ptkc_sdk/ETcpsdk*"
        }
    } else {
    # Network mode
        package { 'ETnethsm':
        ensure        => installed,
        allow_virtual => false,
        provider      => rpm,
        source        => "${eracom_hsm::package_src}/Ptk-C/Linux${package_arch}/network_hsm_access_provider/ETnethsm*"
        }
        package { 'ETcprt':
        ensure        => installed,
        allow_virtual => false,
        provider      => rpm,
        source        => "${eracom_hsm::package_src}/Ptk-C/Linux${package_arch}/ptkc_runtime/ETcprt*",
        require       => Package['ETnethsm']
        }
    }
    # notify { 'keys':
    #   message => $eracom_hsm::keys
    # }

    # Define: edit_env_for_hsm
    # Parameters: users in array
    # arguments
    #

    define edit_env_for_hsm () {
        $user=$name

       # notify { "usr_$user":
       # message => $user
       # }

        if $user == 'root' {
            file_line { "bashrcld_for_$user":
              path  => "/root/.bashrc",
              line  => 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/PTK/lib',
              #match => 'export LD_LIBRARY_PATH',
            }
            file_line { "bashrc_for_$user":
              path  => "/root/.bashrc",
              line  => 'export PATH=$PATH:/opt/PTK/bin',
              #match => 'export PATH',
            }
        } else {
            file_line { "bashrcld_for_$user":
              path  => "/home/$user/.bashrc",
              line  => 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/PTK/lib',
              #match => 'export LD_LIBRARY_PATH',
            }
            file_line { "bashrc_for_$user":
              path  => "/home/$user/.bashrc",
              line  => 'export PATH=$PATH:/opt/PTK/bin',
              #match => 'export PATH',
            }
        }
        ## place here links and othetr FS stuff
        if $eracom_hsm::store =~ /\d+.\d+.\d+.\d+/ {
            ######################################
            # TO-DO NETWORK HSM ENVORONMENT     ##
            ######################################
        } else {
            if $eracom_hsm::store =~ /\// {
                if $user == 'root' {
                    file_line { "bashrcip_for_$user":
                      path  => "/root/.bashrc",
                      line  => "export ET_PTKC_SW_DATAPATH=$eracom_hsm::store"
                    }
                } else {
                    file_line { "bashrcip_for_$user":
                      path  => "/home/$user/.bashrc",
                      line  => 'export ET_PTKC_SW_DATAPATH=$eracom_hsm::store'
                    }
                }
            } else {
                fail("The value of eracom_hsm::store is not correct. You must spesify IP for network HSM or absolute path for HSM emulator. You specify ${eracom_hsm::store}")
            }
        }
    }

    edit_env_for_hsm { $eracom_hsm::os_users:
    }

}

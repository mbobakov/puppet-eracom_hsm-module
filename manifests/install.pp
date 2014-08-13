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
        source        => "${eracom_hsm::package_src}/Ptk-C/Linux${package_arch}/ptkc_sdk/ETcpsdk*",
        before        => Exec['HSM_init']
        }
    } else {
    # Network mode
        package { 'ETnethsm':
        ensure        => installed,
        allow_virtual => false,
        provider      => rpm,
        source        => "${eracom_hsm::package_src}/Ptk-C/Linux${package_arch}/network_hsm_access_provider/ETnethsm*",
        before        => Exec['HSM_init']
        }
        package { 'ETcprt':
        ensure        => installed,
        allow_virtual => false,
        provider      => rpm,
        source        => "${eracom_hsm::package_src}/Ptk-C/Linux${package_arch}/ptkc_runtime/ETcprt*",
        require       => Package['ETnethsm'],
        before        => Exec['HSM_init']
        }
    }

    # Define: edit_env_for_hsm
    define edit_env_for_hsm () {
        $user=$name
        if $user == 'root' {
            file_line { "bashrcld_for_$user":
              path   => "/root/.bashrc",
              line   => 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/PTK/lib',
              before => Exec['HSM_init']
              #match => 'export LD_LIBRARY_PATH',
            }
            file_line { "bashrc_for_$user":
              path   => "/root/.bashrc",
              line   => 'export PATH=$PATH:/opt/PTK/bin',
              before => Exec['HSM_init']
              #match => 'export PATH',
            }
        } else {
            file_line { "bashrcld_for_$user":
              path   => "/home/$user/.bashrc",
              line   => 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/PTK/lib',
              before => Exec['HSM_init']
              #match => 'export LD_LIBRARY_PATH',
            }
            file_line { "bashrc_for_$user":
              path   => "/home/$user/.bashrc",
              line   => 'export PATH=$PATH:/opt/PTK/bin',
              before => Exec['HSM_init']
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
                      line  => "export ET_PTKC_SW_DATAPATH=$eracom_hsm::store"
                    }
                }
            } else {
                fail("The value of eracom_hsm::store is not correct. You must spesify IP for network HSM or absolute path for HSM emulator. You specify ${eracom_hsm::store}")
            }
        }
    }

    edit_env_for_hsm { $eracom_hsm::os_users:
    }

    ###If store changed re-init token with a pin
    exec { 'HSM_init':
      command     => "echo -e \"$eracom_hsm::so_pin\n$eracom_hsm::so_pin\n$eracom_hsm::admin_pin\n$eracom_hsm::admin_pin\n\" | ctconf ",
      path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/PTK/bin',
      environment => 'LD_LIBRARY_PATH=/opt/PTK/lib',
      onlyif      => 'test $(echo -e \'\n\n\n\n\' | ctconf 2> /dev/null |grep -c \'Initializing\' ) -eq 1',
      #refreshonly => true,
    }

  class { 'eracom_hsm::slot': } ->
  class { 'eracom_hsm::key': }

}

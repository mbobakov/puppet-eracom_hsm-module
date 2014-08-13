# NOTE: the full path of this file is important and is required by Puppet's
#       autoloading mechanism.
#
#       Providers must be placed in the following path:
#       lib/puppet/provider/<type>/<provider>.rb
#
#       Puppet will essentially require lib/puppet/provider/<type>/*.rb
#       for each type found in lib/puppet/type/


# example for loading arbitrary code shipped with your module
#require File.join(File.dirname(__FILE__), "../../../", "foobar")

Puppet::Type.type(:slot).provide(:eracom, :parent => Puppet::Provider) do

  desc "Normal Eracom provider ."

  # if you have multpile providers, use these methods to automatically select
  # the correct one based on facts provided by facter

  # confine    :operatingsystem => [ :darwin ]
  # defaultfor :operatingsystem => :darwin

  # must be implemented for ensurable()
  def create
    #create new slot
    system("echo -e \"#{@resource[:admin_pin]}\n\" |ctconf -c1 >/dev/null 2>&1 ")
    #get first uninitiazed token
    token_number = `ctkmu l | grep 'uninitialised token'|grep -oE 'Slot [0-9]+'|cut -d' ' -f2|sort |head -1`
    system("echo -e \"#{@resource[:user_pin]}\n#{@resource[:user_pin]}\n#{@resource[:user_pin]}\n#{@resource[:user_pin]}\n\" |ctkmu t -l #{@resource[:name]} -s#{token_number.strip} >/dev/null 2>&1")
  end

  # must be implemented for ensurable()
  def destroy
    #search all slots by NAME
    
    true
  end

  # must be implemented for ensurable()
  def exists?
    system("test $(ctkmu l |grep Slot|grep -v AdminToken |sed -nre 's/ {2,}\(Slot|\)//g;p'|grep -c #{@resource[:name]}) -ge 1")
  end

  # # Return the mode as an octal string, not as an integer.
  # def mode
  #   self.class.send_log(:debug, "call mode()")
  #   if File.exists?(@resource[:name])
  #     "%o" % (File.stat(@resource[:name]).mode & 007777)
  #   else
  #     :absent
  #   end
  # end

  # # Set the file mode, converting from a string to an integer.
  # def mode=(value)
  #   self.class.send_log(:debug, "call mode=(#{value})")
  #   File.chmod(Integer("0" + value), @resource[:name])
  # end

end
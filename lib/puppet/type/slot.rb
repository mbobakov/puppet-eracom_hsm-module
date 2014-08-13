Puppet::Type.newtype(:slot) do
    @doc = "Manage slots and tokens in Eracom "

    ensurable

    newparam(:token_name) do
        desc "The token name"
        isnamevar
    end


    newparam(:admin_pin) do
        desc "The SO pin for token initialization"
    end
    
    newparam(:user_pin) do
        desc "The user pin for new token"
    end

end

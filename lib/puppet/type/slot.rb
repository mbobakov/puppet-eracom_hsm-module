Puppet::Type.newtype(:slot) do
    @doc = "Manage slots and tokens in Eracom "

    ensurable

    newparam(:token_name) do
        desc "The token name"
        isnamevar
    end


    newparam(:number) do
        desc "The slot number"

        validate do |value|
            unless value =~ /^\d+/
                raise ArgumentError , "%s is not a valid number" % value
            end
        end
    end

    newparam(:path) do
        desc "Destination path"

        validate do |value|
            unless value =~ /^\/[a-z0-9]+/
                raise ArgumentError , "%s is not a valid file path" % value
            end
        end
    end
end

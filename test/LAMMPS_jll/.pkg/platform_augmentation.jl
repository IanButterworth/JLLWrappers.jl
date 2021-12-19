using Base.BinaryPlatforms
using Preferences

function known_abis()
    return (:MicrosoftMPI, :MPICH, :MPItrampoline)
end

const LAMMPS_UUID = parse(Base.UUID, "5b3ab26d-9607-527c-88ea-8fe5ba57cafe")

const abi = load_preference(LAMMPS_UUID, "abi", Sys.iswindows() ? :MicrosoftMPI : :MPICH)

function set_abi(abi)
    if abi ∉ known_abis()
        error("""
            The MPI ABI $abi is not supported.
            Please set the MPI ABI to one of the following:
            $(known_abis())
        """)
    end
    set_preferences!(LAMMPS_UUID, "abi" => string(abi), force=true)
    @warn "The MPI abi has changed, you will need to restart Julia for the change to take effect" abi
    return abi
end

function augment_platform!(platform)
    if !haskey(platform, "mpi")
        platform["mpi"] = string(abi)
    end
    return platform
end





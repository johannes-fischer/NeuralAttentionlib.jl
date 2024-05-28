####################  Dataless Mask  ####################

AxesConstraint(::AbstractAttenMask{DATALESS}) = (NDimConstraint(2, true),)

struct CausalMask <: AbstractAttenMask{DATALESS} end

Base.@propagate_inbounds maskgetindex(::Dims, ::CausalMask, i::Integer, j::Integer, _::Integer...) = j >= i

struct LocalMask <: AbstractAttenMask{DATALESS}
    width::Int
end

Base.@propagate_inbounds maskgetindex(::Dims, m::LocalMask, i::Integer, j::Integer, _::Integer...) = j - m.width < i < j + m.width

struct RandomMask <: AbstractAttenMask{DATALESS}
    p::Float64
end

Base.@propagate_inbounds maskgetindex(::Dims, m::RandomMask, _::Integer...) = rand() > m.p

AxesConstraint(m::RandomMask) = ()
randomness(::RandomMask) = static(true)

struct BandPartMask <: AbstractAttenMask{DATALESS}
    l::Int
    u::Int
end

Base.@propagate_inbounds maskgetindex(::Dims, m::BandPartMask, i::Integer, j::Integer, _::Integer...) = (m.l < 0 || i <= j + m.l) && (m.u < 0 || i >= j - m.u)

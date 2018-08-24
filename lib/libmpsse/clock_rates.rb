module LibMpsse
  # Common clock rates
  ClockRates = enum(
    :one_hundred_khz,  100_000,
    :four_hundred_khz, 400_000,
    :one_mhz,          1_000_000,
    :two_mhz,          2_000_000,
    :five_mhz,         5_000_000,
    :six_mhz,          6_000_000,
    :ten_mhz,          10_000_000,
    :twelve_mhz,       12_000_000,
    :fifteen_mhz,      15_000_000,
    :thirty_mhz,       30_000_000,
    :sixty_mhz,        60_000_000
  )
end

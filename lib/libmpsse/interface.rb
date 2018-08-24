require 'ftdi'

module LibMpsse
  Interface = enum(
    :iface_any, Ftdi::Interface[:interface_any],
    :iface_a, Ftdi::Interface[:interface_a],
    :iface_b, Ftdi::Interface[:interface_b],
    :iface_c, Ftdi::Interface[:interface_c],
    :iface_d, Ftdi::Interface[:interface_d]
  )
end

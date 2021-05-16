// TODO: move this to a provider written in Go

variable "mac" {
  type = string
}

variable "prefix" {
  type        = string
  description = "IPv6 CIDR-prefix to use for the address"
  default     = "fe80::/64"

  validation {
    condition     = can(regex("^([0-9a-f]{1,4}:{0,2})+/64$", var.prefix))
    error_message = "Prefix needs to be an IPv6 CIDR prefix with a length of 64."
  }
}

# algorithm: https://geek-university.com/ccna/ipv6-eui-64-calculation/
locals {
  octets          = split(":", var.mac)
  first_octet     = parseint(local.octets[0], 16)
  first_octet_bin = format("%08b", local.first_octet)
  first_octet_pre = substr(local.first_octet_bin, 0, 6)
  seventhbit      = substr(local.first_octet_bin, 6, 1)
  eighthbit       = substr(local.first_octet_bin, 7, 1)

  seventhbit_flipped  = local.seventhbit == "0" ? "1" : "0"
  first_octet_updated = join("", [local.first_octet_pre, local.seventhbit_flipped, local.eighthbit])
  first_octet_num     = parseint(local.first_octet_updated, 2)
  first_octet_hex     = format("%02x", local.first_octet_num)

  octets_eui64 = concat([local.first_octet_hex], slice(local.octets, 1, 3), ["ff", "fe"], slice(local.octets, 3, 6))
  hextets      = [for chunk in chunklist(local.octets_eui64, 2) : join("", chunk)]
  eui64        = join(":", local.hextets)

  prefix_addr         = cidrhost(var.prefix, 0)
  prefix_hextet_count = length(compact(split(":", local.prefix_addr)))
  # when the prefix has 4 hextets, we need to remove the double-colon between prefix and eui64
  # yes, this is very hacky, we need Go for this
  prefix_for_addr = local.prefix_hextet_count == 4 ? trimsuffix(local.prefix_addr, "::") : trimsuffix(local.prefix_addr, ":")

  addr = join("", [local.prefix_for_addr, ":", local.eui64])
}

output "address" {
  value = lower(local.addr)
}

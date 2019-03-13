resource "oci_core_virtual_network" "K8SVNC" {
  cidr_block     = "${var.VPC-CIDR}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "K8S-VNC"
  dns_label      = "k8s"
}

resource "oci_core_internet_gateway" "K8SIG" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "K8S-IG"
  vcn_id         = "${oci_core_virtual_network.K8SVNC.id}"
}

resource "oci_core_route_table" "RouteForK8S" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.K8SVNC.id}"
  display_name   = "RouteTableForK8SVNC"

  route_rules {
    destination        = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.K8SIG.id}"
  }
}

resource "oci_core_security_list" "WorkerSecList" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "WorkerSecList"
  vcn_id         = "${oci_core_virtual_network.K8SVNC.id}"

  ingress_security_rules = [{
    protocol = "all"
    source   = "${lookup(var.network_cidrs,"workerSubnetAD1")}"
    stateless = true
  },
  { protocol = "all"
    source   = "${lookup(var.network_cidrs,"workerSubnetAD2")}"
    stateless = true
   },
   { protocol = "all"
     source   = "${lookup(var.network_cidrs,"workerSubnetAD3")}"
     stateless = true
   },
   { protocol = "1"
     source   = "0.0.0.0/0"
     icmp_options {
       "type" = 3
       "code" = 4
       }
     stateless = false
   },
   { protocol = "6"
     source   = "130.35.0.0/16"
     stateless = false
     tcp_options {
       "max" = 22
       "min" = 22
       }
   },
   { protocol = "6"
     source   = "134.70.0.0/17"
     stateless = false
     tcp_options {
       "max" = 22
       "min" = 22
       }
   },
   { protocol = "6"
     source   = "138.1.0.0/16"
     stateless = false
     tcp_options {
       "max" = 22
       "min" = 22
       }
   },
   { protocol = "6"
     source   = "140.91.0.0/17"
     stateless = false
     tcp_options {
       "max" = 22
       "min" = 22
       }
   },
   { protocol = "6"
     source   = "147.154.0.0/16"
     stateless = false
     tcp_options {
       "max" = 22
       "min" = 22
       }
   },
   { protocol = "6"
     source   = "192.29.0.0/16"
     stateless = false
     tcp_options {
       "max" = 22
       "min" = 22
       }
   },
   { protocol = "6"
     source   = "0.0.0.0/0"
     stateless = false
     tcp_options {
       "min" = 30000
       "max" = 32767
       }
   },
  ]

  egress_security_rules = [{
    destination = "0.0.0.0/0"
    protocol    = "all"
  },
  {
    protocol = "all"
    destination   = "${lookup(var.network_cidrs,"workerSubnetAD1")}"
    stateless = true
  },
  { protocol = "all"
    destination   = "${lookup(var.network_cidrs,"workerSubnetAD2")}"
    stateless = true
   },
   { protocol = "all"
     destination   = "${lookup(var.network_cidrs,"workerSubnetAD3")}"
     stateless = true
   },
]

}

resource "oci_core_security_list" "LoadBalancerSecList" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "LoadBalancerSecList"
  vcn_id         = "${oci_core_virtual_network.K8SVNC.id}"

  ingress_security_rules = [
  { protocol = "6"
     source   = "0.0.0.0/0"
     stateless = true
   },
   { protocol = "6"
     source   = "0.0.0.0/0"
     stateless = false
     tcp_options {
       "min" = 80
       "max" = 80
       }
   },
   { protocol = "6"
     source   = "0.0.0.0/0"
     stateless = false
     tcp_options {
       "min" = 443
       "max" = 443
       }
   },
  ]

  egress_security_rules = [{
    destination = "0.0.0.0/0"
    protocol    = "6"
    stateless = false
  },

]

}

resource "oci_core_subnet" "workerSubnetAD1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[0],"name")}"
  cidr_block          = "${lookup(var.network_cidrs, "workerSubnetAD1")}"
  display_name        = "workerSubnetAD1"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.K8SVNC.id}"
  route_table_id      = "${oci_core_route_table.RouteForK8S.id}"
  security_list_ids   = ["${oci_core_security_list.WorkerSecList.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.K8SVNC.default_dhcp_options_id}"
  dns_label           = "worker1"
}

resource "oci_core_subnet" "workerSubnetAD2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[1],"name")}"
  cidr_block          = "${lookup(var.network_cidrs, "workerSubnetAD2")}"
  display_name        = "workerSubnetAD2"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.K8SVNC.id}"
  route_table_id      = "${oci_core_route_table.RouteForK8S.id}"
  security_list_ids   = ["${oci_core_security_list.WorkerSecList.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.K8SVNC.default_dhcp_options_id}"
  dns_label           = "worker2"
}

resource "oci_core_subnet" "workerSubnetAD3" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[2],"name")}"
  cidr_block          = "${lookup(var.network_cidrs, "workerSubnetAD3")}"
  display_name        = "workerSubnetAD3"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.K8SVNC.id}"
  route_table_id      = "${oci_core_route_table.RouteForK8S.id}"
  security_list_ids   = ["${oci_core_security_list.WorkerSecList.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.K8SVNC.default_dhcp_options_id}"
  dns_label           = "worker3"
}

resource "oci_core_subnet" "LoadBalancerSubnetAD1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[0],"name")}"
  cidr_block          = "${lookup(var.network_cidrs, "LoadBalancerSubnetAD1")}"
  display_name        = "LoadBalancerSubnetAD1"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.K8SVNC.id}"
  route_table_id      = "${oci_core_route_table.RouteForK8S.id}"
  security_list_ids   = ["${oci_core_security_list.LoadBalancerSecList.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.K8SVNC.default_dhcp_options_id}"
  dns_label           = "loadbalancer1"
}
resource "oci_core_subnet" "LoadBalancerSubnetAD2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[1],"name")}"
  cidr_block          = "${lookup(var.network_cidrs, "LoadBalancerSubnetAD2")}"
  display_name        = "LoadBalancerSubnetAD2"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.K8SVNC.id}"
  route_table_id      = "${oci_core_route_table.RouteForK8S.id}"
  security_list_ids   = ["${oci_core_security_list.LoadBalancerSecList.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.K8SVNC.default_dhcp_options_id}"
  dns_label           = "loadbalancer2"
}

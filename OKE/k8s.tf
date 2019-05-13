
resource "oci_containerengine_cluster" "k8s_cluster" {
	compartment_id = "${var.compartment_ocid}"
	kubernetes_version = "v1.11.9"
	name = "k8s_cluster"
	vcn_id = "${oci_core_virtual_network.K8SVNC.id}"


	options {

		add_ons {
			is_kubernetes_dashboard_enabled = true
			is_tiller_enabled = true
		}
		service_lb_subnet_ids = ["${oci_core_subnet.LoadBalancerSubnetAD1.id}","${oci_core_subnet.LoadBalancerSubnetAD2.id}"]
	}
}

resource "oci_containerengine_node_pool" "K8S_pool1" {
	#Required
	cluster_id = "${oci_containerengine_cluster.k8s_cluster.id}"
	compartment_id = "${var.compartment_ocid}"
  kubernetes_version = "v1.11.9"
	name = "K8S_pool1"
	node_image_name = "${var.worker_ol_image_name}"
	node_shape = "${var.k8sWorkerShape}"
	subnet_ids = ["${oci_core_subnet.workerSubnetAD1.id}","${oci_core_subnet.workerSubnetAD2.id}","${oci_core_subnet.workerSubnetAD3.id}"]

	quantity_per_subnet = "1"
#	ssh_public_key = "${var.node_pool_ssh_public_key}"
}


data "oci_containerengine_cluster_kube_config" "test_cluster_kube_config" {
	#Required
	cluster_id = "${oci_containerengine_cluster.k8s_cluster.id}"
}


resource "local_file" "mykubeconfig" {
    content     = "${data.oci_containerengine_cluster_kube_config.test_cluster_kube_config.content}"
    filename = "./mykubeconfig"
}

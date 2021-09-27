resource "ibm_cos_bucket" "flowlogs" {
  bucket_name          = var.bucket_name
  resource_instance_id = var.cos_instance
  storage_class        = "standard"
  region_location      = var.bucket_region
}

resource "ibm_is_flow_log" "subnet" {
  count          = length(var.subnets)
  depends_on     = [ibm_cos_bucket.flowlogs]
  name           = "subnet-flow-log-collector-${count.index + 1}"
  target         = element(var.subnets, count.index + 1)
  active         = true
  storage_bucket = ibm_cos_bucket.flowlogs.bucket_name
}

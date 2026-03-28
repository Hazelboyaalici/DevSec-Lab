output "instance_ip" {
  description = "35.192.173.15"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "instance_name" {
  description = "my-lms-app"
  value       = google_compute_instance.vm_instance.name
}

output "instance_zone" {
  description = "The zone the instance was deployed to"
  value       = google_compute_instance.vm_instance.zone
}

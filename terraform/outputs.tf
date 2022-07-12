// load balancer endpoint for nginx service
output "lb_ip" {
  value = kubernetes_service.hello_world.status.0.load_balancer.0.ingress.0.hostname
}

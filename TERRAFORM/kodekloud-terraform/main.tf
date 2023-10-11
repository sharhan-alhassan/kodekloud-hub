resource "local_file" "games" {
  filename = "/home/sharhan/DEV/TERRAFORM/kodekloud-terraform/terraform-intro/sample.txt"
  content  = "sharhan"

}

resource "random_pet" "pet" {
  prefix = "ms"
}


resource "time_" "game" {
  
}
terraform {
    backend "gcs" {
        credentials = "./key.json"
        bucket = "terraform-tfstate-myapp"
        prefix = "dev-myapp"
    }
}
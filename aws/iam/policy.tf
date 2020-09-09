data "template_file" "cloudhealth" {
  template = file("${path.module}/cloudhealth-policy.json")
}

resource "aws_iam_policy" "cloudhealth" {
  name        = "CloudHealthAllCloud"
  path        = "/"
#  description = "Allow Role to Assume role"
  policy      = data.template_file.cloudhealth.rendered
}

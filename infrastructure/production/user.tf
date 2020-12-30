resource "aws_iam_user" "joelhillische" {
  name          = "joelhillische"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_ssh_key" "user" {
  username   = aws_iam_user.joelhillische.name
  encoding   = "SSH"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAsTzGyrKoLYkgwAvnd6opV1xe/KHTUPHXq91lx+Gv1lmpHXpN2XuXQUZuuQln7pRu+REBV1aAk7ATPJBtF6ckoIaqCgUr8kvTUrkhZ/Mui6MbjokPE1CHvzVowjHnjfVPpd+DwlpyQka91E14csyt3ifwzXUsY51hrX3S01ovILZDzMavhZ7I6NgmePYEBkkJ3eAoscBoM9USSk/1jfm/1dX+HTA7fowRungVDjtGnsHIGHJ1l8M2T8Uw/0VnH/pKOO4BRR9GuS1f5HXf1BDZkYjqdzx2Dp30bl6N6+uC6+Zv7UQplJIP4rTmMbFjsjzYRonk3exZmoPTY1Zum7hf2EJjXsSrz11dNou2WanQeHdFFSFzaa5n49K+GqQVakqoJZbLC3ltTW3GXq/pe6wMr/NamTrMx+KbNt2zsUxCosnjv1a7aPCuf2j0s2xBNfuXebpUp0zq+8b49jvY/FeP6UwNV1NoxG/TTkMgBte2C4kQn9U9VrqSpduXGCHtybMC6NaMjDH9oU59Mxj9swEbeUjBlu3IxhwCGnrkA5lcxCGKQbGOfa/KAHGwEcNXuYI6pjw0u5Le2ikB3ldbNOeaX/YKs6DXipVR56ygqh4EXOKiJg/dQI0+NL8cZZ4MsAfbqBlGeIKI3lYScthlFW3AxpZ0Mo2cDVh8BVBiqPdTZ2s="
}

resource "aws_iam_group" "administrators" {
  name = "administrators"
  path = "/users/"
}

resource "aws_iam_group_membership" "administrators" {
  name = "administrators-membership"

  users = [
    aws_iam_user.joelhillische.name,
  ]

  group = aws_iam_group.administrators.name
}

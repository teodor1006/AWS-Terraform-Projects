resource "aws_instance" "vprofile-bastion" {
  ami                    = lookup(var.amis, var.region)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.vprofilekey.key_name
  subnet_id              = module.vpc.public_subnets[0]
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.vprofile-bastion-sg.id]
 
  tags = {
    Name    = "vprofile-bastion"
    Project = "vprofile"
  }

  provisioner "file" {
    content     = templatefile("templates/db-deploy.tftpl", { rds-endpoint = aws_db_instance.vprofile-rds.address, dbuser = var.dbuser, dbpass = var.dbpass })
    destination = "/tmp/vprofile-dbdeploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/vprofile-dbdeploy.sh",
      "sudo /tmp/vprofile-dbdeploy.sh"
    ]
  }

  connection {
    user        = var.user
    private_key = file(var.priv_key_path)
    host        = aws_instance.vprofile-bastion.public_ip
  }

  depends_on = [aws_db_instance.vprofile-rds]
}

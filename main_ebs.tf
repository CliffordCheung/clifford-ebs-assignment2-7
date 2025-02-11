resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 1
  iops              = 3000
  throughput        = 125
  type              = "gp3"

  tags = {
    Name = "clifford-ebs-volume-0211"
  }

}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.public.id

}
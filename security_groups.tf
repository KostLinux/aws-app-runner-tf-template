resource "aws_security_group" "app_runner" {
    name = "app_runner"
    description = "AppRunner Security Group"
    vpc_id = data.aws_vpc.default.id
    tags = {
        Name = "AppRunner Security Group"
        Type = "Private"
    }
}

resource "aws_security_group_rule" "allow_https" {
    security_group_id = aws_security_group.app_runner.id

    type = "ingress"
    cidr_blocks = [
        "1.1.1.1"
    ]
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "Allow HTTPS Inbound"

}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "allow_egress" {
    security_group_id = aws_security_group.app_runner.id

    type = "egress"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    from_port = -1
    to_port = -1
    protocol = "all"
    description = "Allow all outbound"
}
resource "aws_ses_domain_identity" "this" {
  domain = local.route53_public_hosted_zone_name
}

resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

resource "aws_route53_record" "dkim" {
  count = 3

  zone_id = local.route53_public_hosted_zone_id
  name    = "${element(aws_ses_domain_dkim.this.dkim_tokens, count.index)}._domainkey.${aws_ses_domain_identity.this.domain}."
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.this.dkim_tokens, count.index)}.dkim.amazonses.com"]
}


resource "aws_route53_record" "ses_verification" {
  zone_id = local.route53_public_hosted_zone_id
  name    = "_amazonses.${aws_ses_domain_identity.this.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.this.verification_token]
}

resource "aws_ses_domain_identity_verification" "ses_verification" {
  domain = aws_ses_domain_identity.this.id

  depends_on = [aws_route53_record.ses_verification]
}

resource "aws_route53_record" "dmarc_policy" {
  zone_id = local.route53_public_hosted_zone_id
  name    = "_dmarc.${aws_ses_domain_identity.this.domain}"
  type    = "TXT"
  ttl     = "3600"
  records = ["v=DMARC1; p=reject; pct=100; rua=mailto:dmarc-rua@dmarc.service.gov.uk"]
}

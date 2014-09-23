#!perl

# 查看图形验证码的图片效果
# 此脚本会在工作目录生成1000个png文件，从000到999
# 依赖于curl
# usage: 
# perl $0 captcha_url

use strict;

$|++;

sub usage
{
	die "perl $0 captcha_url\n";
}

my $url = shift @ARGV;
if (!$url)
{
	&usage();
}

my $max = 999;
foreach my $count (0 .. $max)
{
	printf("getting %d/%d\r", $count, $max);
	system(sprintf("curl -s -o %03d.png %s", $count, $url));
}

print "\nok\n";

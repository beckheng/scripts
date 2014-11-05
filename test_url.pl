#!perl

# 没有siege，用我啦~~~
# 此脚本会访问N次指定url，并显示平均访问时间
# 依赖于curl
# usage: 
# perl $0 count url

use strict;

$|++;

sub usage
{
	die "perl $0 count url\n";
}

my $total_count = shift @ARGV;
if (!$total_count)
{
	$total_count = 10;
}

my $url = shift @ARGV;
if (!$url)
{
	&usage();
}

my $min;
my $max=0;
my $total_time=0;
foreach my $count (1 .. $total_count)
{
	printf("getting %d/%d\r", $count, $total_count);
	my $out = `curl -o /dev/null -s -w \%{time_total} $url`;
	
	if (!defined $min)
	{
		$min=$out;
	}
	
	if ($out<$min)
	{
		$min=$out;
	}
	
	if ($out>$max)
	{
		$max=$out;
	}
	
	$total_time+=$out;
	
	select undef,undef,undef,0.5;
}

print "\nok!!! statistics:\n";
printf "request: %d min: %.3f max: %.3f total: %.3f avg: %.3f\n", $total_count, $min,$max,$total_time, $total_time/$total_count;
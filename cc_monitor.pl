#!perl

# 监控drupal sites下的module文件，有改变则用drush cc清除cache
# 此脚本需要在drupal_site_path对应的目录下执行
# usage: 
# 1. cd the_drupal_site_path
# 2. perl $0 path1 path2 path..n

use strict;

use File::ChangeNotify;

sub usage
{
	die "perl $0 path1 path2 path..n\n";
}

my @site_path = @ARGV;
if (!@site_path)
{
	&usage();
}

my $watcher = File::ChangeNotify->instantiate_watcher(
	directories => [@site_path],
	filter => qr/\.(?:module|inc|info|php)$/,
	sleep_interval => 1,
);

print "monitor @site_path, wait for events\n\n";

while (my @events = $watcher->wait_for_events())
{
	print "\nclear cache at: " . scalar(localtime()) . "\n";
	system('drush cc all');	
	print "\n";
}

#!perl

# 监控drupal sites下的module文件，有改变则用drush cc清除cache
# 此脚本需要在drupal_site_path对应的目录下执行，不然IPC通信结果不正确
# usage: 
# 1. cd the_drupal_site_path
# 2. perl $0 drupal_site_path

use strict;

use File::ChangeNotify;
use IPC::Open3;

sub usage
{
	die "perl $0 drush_site_path\n";
}

my $site_path = shift @ARGV;
if (!$site_path)
{
	&usage();
}

local(*CIN, *COUT, *CERR);

my $watcher = File::ChangeNotify->instantiate_watcher(
	directories => $site_path,
	filter => qr/\.(?:module|inc)$/,
	sleep_interval => 1,
);

print "monitor $site_path, wait for events\n\n";

while (my @events = $watcher->wait_for_events())
{
	print "\nclear cache at: " . scalar(localtime()) . "\n";
	my $pid = open3(*CIN, *COUT, *CERR, 'drush cc');
	print CIN "1\n"; # choose clear all cache
	close(CIN);
	my @outlines = <COUT>;
	my @errlines = <CERR>;
	
	print "STDOUT:\n", @outlines, "\n";
	print "STDERR:\n", @errlines, "\n\n";
	
	close(COUT);
	close(CERR);

	waitpid($pid, 0);
}


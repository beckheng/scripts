#!/usr/bin/perl

use strict;

# read hosts from file and update /etc/hosts

if (@ARGV != 1)
{
	die "usage: perl $0 file.hosts\n";
}

my $file = $ARGV[0];

my %hosts = ();

if (open(UP, $file))
{
	while (my $line = <UP>)
	{
		# check comment line
		if ($line =~ /^#/)
		{
			next;
		}

		$line =~ s/\r?\n$//g;

		# check empty line
		if ($line =~ /^\s*$/)
		{
			next;
		}

		my @host = split/\s+/, $line;

		for (my $i = 1; $i < @host; ++$i)
		{
			$hosts{$host[$i]} = $host[0];
		}
	}
	close(UP);
}
else
{
	die "open $file error: $!\n";
}

if (scalar(keys %hosts) == 0)
{
	die "no hosts to update\n";
}

my $sysHostsFile = '/etc/hosts';

if (open(HOST, $sysHostsFile))
{
	my $content = '';

	while (my $line = <HOST>)
	{
		# check comment line
		if ($line =~ /^#/)
		{
			$content .= $line;
			next;
		}

		$line =~ s/\r?\n$//g;

		# check empty line
		if ($line =~ /^\s*$/)
		{
			$content .= "\n";
			next;
		}

		my @host = split/\s+/, $line;

		for (my $i = 1; $i < @host; ++$i)
		{
			if (exists $hosts{$host[$i]})
			{
				$content .= $hosts{$host[$i]} . "\t" . $host[$i] . "\n";
				delete $hosts{$host[$i]};
			}
			else
			{
				$content .= $host[0] . "\t" . $host[$i] . "\n";
			}
		}
	}
	close(HOST);

	foreach my $h (keys %hosts)
	{
		$content .= $hosts{$h} . "\t" . $h . "\n";
	}

	if (open(WRITE, ">$sysHostsFile"))
	{
		print WRITE $content;
		close(WRITE);
	}
	else
	{
		die "open file $sysHostsFile for writing error: $!\n";
	}
}
else
{
	die "open $sysHostsFile error: $!\n";
}


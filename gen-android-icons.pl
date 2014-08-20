#!perl

# 使用此脚本从原有的icon-1024.png生成渠道与平台所需要的各个尺寸的icon
# 并会复制平台所需要的尺寸到对应目录
# 要在对应的icon目录下执行，现定为PROJECT_ROOT/psd/icon

use strict;

my $iconName = shift @ARGV || 'ic_launcher';

foreach my $size (qw(16 28 29 32 40 48 50 57 58 72 75 76 80 90 96 100 108 114 120 136 144 152 192 512))
{
	system("convert -resize \"$size\" $iconName-1024.png $iconName-$size.png");

	if ($size == 32)
	{
		system("cp $iconName-$size.png ../../res/drawable-ldpi/$iconName.png");
	}

	if ($size == 48)
	{
		system("cp $iconName-$size.png ../../res/drawable-mdpi/$iconName.png");
	}

	if ($size == 72)
	{
		system("cp $iconName-$size.png ../../res/drawable-hdpi/$iconName.png");
	}

	if ($size == 96)
	{
		system("cp $iconName-$size.png ../../res/drawable-xhdpi/$iconName.png");
	}

	if ($size == 144)
	{
		if (!-e "../../res/drawable-xxhdpi")
		{
			print "create drawable-xxhdpi directory\n";
			mkdir("../../res/drawable-xxhdpi");
		}

		system("cp $iconName-$size.png ../../res/drawable-xxhdpi/$iconName.png");
	}
}

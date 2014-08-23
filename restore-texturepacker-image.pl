#!perl

# 把TexturePacker发布的文件，还原为原始图片文件，需要ImageMagick工具支持
# 支持格式
# 1. xml

# usage:
# perl $0 format_file

use strict;

use File::Basename;
use XML::TreeBuilder;
use Data::Dumper;

$| = 1;

my %handler = (
	'xml' => \&restoreXMLFormat,
);

my $formatFile = shift @ARGV;
if (!$formatFile)
{
	die "usage:\nperl $0 format_file\n";
}

if (!-e $formatFile)
{
	die "请先输入一个存在的格式文件\n";
}

my ($filename, $dirname, $suffix) = fileparse($formatFile, ".xml");
$suffix =~ s/^\.//;
#print "$filename, $dirname, $suffix\n";
if (!-e $filename)
{
	mkdir($filename);
}

my $type = lc($suffix);

if (exists $handler{$type})
{
	my $method = $handler{$type};
	$method->();
	
	print "All Done!\n";
}
else
{
	die "未支持的类别: $type\n";
}

sub restoreXMLFormat
{
	my $tree = XML::TreeBuilder->new();
	$tree->parse_file($formatFile);
	
	my $TextureAtlas = $tree->find('TextureAtlas');
	my $imagePath = $TextureAtlas->attr('imagePath', '');
	
	print "Extract png from $imagePath\n";
	
	my @SubTextures = $TextureAtlas->find('SubTexture');
	foreach my $subTexture (@SubTextures)
	{
		my $name = $subTexture->attr('name');
		my $x = $subTexture->attr('x');
		my $y = $subTexture->attr('y');
		my $width = $subTexture->attr('width');
		my $height = $subTexture->attr('height');
#		my $frameX = $subTexture->attr('frameX');
#		my $frameY = $subTexture->attr('frameY');
#		my $frameWidth = $subTexture->attr('frameWidth');
#		my $frameHeight = $subTexture->attr('frameHeight');
		
		print "generate png $filename/$name.png at ${width}x${height}+${x}+${y}\n";
		system("convert $imagePath -crop ${width}x${height}+${x}+${y} $filename/$name.png");
	}
	
	$tree = $tree->delete();
}

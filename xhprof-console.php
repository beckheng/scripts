<?php
// by default assume that xhprof_html & xhprof_lib directories
// are at the same level.

// 需要设置XHPROF_LIB_ROOT环境变量指向xhprof_lib目录
// Linux下如: export XHPROF_LIB_ROOT=/vagrant/php-lib/xhprof-0.9.2/xhprof_lib

// 其他参数:
// r: run_id
// u: url

$GLOBALS['XHPROF_LIB_ROOT'] = $_SERVER['XHPROF_LIB_ROOT'];

include_once $GLOBALS['XHPROF_LIB_ROOT'].'/display/xhprof.php';

$options=getopt('r:t:u:');
if (!isset($options['t']))
{
	$options['t']='urlencode';
}

$files = array();

$dir = ini_get("xhprof.output_dir");
$xhprof_runs_impl = new XHProfRuns_Default($dir);

if ($dh = opendir($dir))
{
	while (($file = readdir($dh)) !== FALSE)
	{
		if ('.' === $file || '..' === $file)
		{
			continue;
		}
		
		$dot_pos = strpos($file, '.');
		if (FALSE === $dot_pos)
		{
			continue;
		}
		
		$run_id = substr($file, 0, $dot_pos);
		$type = substr($file, $dot_pos+1);
		
		if ('urlencode' === $options['t'])
		{
			//$url = base64_decode($type);
			$url = urldecode($type);
		}
		else 
		{
			$url = '';
		}
		
		if (isset($options['r']))
		{
			if (FALSE === strpos($run_id, $options['r']))
			{
				continue;
			}
		}
		
		if (isset($options['u']))
		{
			if ($url !== $options['u'])
			{
				continue;
			}
		}
		
		$files[] = array(
			'run_id'=>$run_id,
			'type'=>$type,
			'url'=>$url,
		);
	}
	closedir($dh);
}

$totals = 0;
$sort_col = 'mu';

$output_format = "%4s	%8s	%8s	%8s	%s %s\n";

printf($output_format, 'ct', 'cpu', 'mu', 'pmu', 
	/*'excl_cpu', 'excl_mu', 'excl_pmu',*/ 
	'url', 'fn');

foreach ($files as $file)
{
	$desc = '';
	$xhprof_data = $xhprof_runs_impl->get_run($file['run_id'],
			$file['type'],
			$desc);
	$symbol_tab=xhprof_compute_flat_info($xhprof_data, $totals);
	
	$flat_data = array();
	foreach ($symbol_tab as $symbol => $info) {
		$tmp = $info;
		$tmp["fn"] = $symbol;
		$tmp['url'] = $file['url'];
		$flat_data[] = $tmp;
	}
	usort($flat_data, 'sort_cbk');
	
	foreach ($flat_data as $data)
	{
		printf($output_format,
				$data['ct'],
				$data['cpu'],
				$data['mu'],
				$data['pmu'],
				//$data['excl_cpu'],
				//$data['excl_mu'],
				//$data['excl_pmu'],
				$data['url'],
				$data['fn']
		);
	}
}

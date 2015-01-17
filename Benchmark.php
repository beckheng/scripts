<?php
/**
Example:
Benchmark::timethese(
	100000,
	array(
		'split' => function (){return split('[/]', '04/30/1973');},
		'explode' => function (){return explode('/', '04/30/1973');},
	)
);

output:

                            func               run            time           %         mem
                         explode            100000          0.6222       43.40          32
                           split            100000          0.8114       56.60         128
 */
class Benchmark
{
	public static function timethese($count, $funcs)
	{
		$result = array();
		$totalTime = 0;
		
		foreach ($funcs as $fname => $method)
		{
			$start = microtime(true);
			$mem = memory_get_usage();
			for ($i = 0; $i < $count; ++$i)
			{
				$method();
			}
			$result[$fname]['mem'] = memory_get_usage() - $mem;
			$end = microtime(true);
			
			$result[$fname]['time'] = $end - $start;
			$totalTime += ($end - $start);
		}
		
		// output result
		uasort($result, __CLASS__ . '::cmp_result');
		$sep = php_sapi_name() === 'cli' ? "\n" : '<br/>';
		printf("\n%32s	%10s	%10s	%6s	%10s" . $sep, 'func', 'run', 'time', '%', 'mem');
		foreach ($result as $fname => $info)
		{
			printf("%32s	%10d	%10.4f	%6.2f	%10ld" . $sep, 
				$fname, $count, $info['time'], $info['time']/$totalTime*100, $info['mem']);
		}
	}
	
	private static function cmp_result($a, $b)
	{
		if ($a['time'] == $b['time'])
		{
			return 0;
		}
		
		return $a['time'] < $b['time'] ? -1 : 1;
	}
}

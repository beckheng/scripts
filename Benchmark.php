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

                            func               run            time           %
                         explode            100000          0.4853       43.11
                           split            100000          0.6404       56.89
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
			for ($i = 0; $i < $count; ++$i)
			{
				$method();
			}
			$end = microtime(true);
			
			$result[$fname] = $end - $start;
			$totalTime += ($end - $start);
		}
		
		// output result
		uasort($result, __CLASS__ . '::cmp_result');
		$sep = php_sapi_name() === 'cli' ? "\n" : "<br/>";
		printf("\n%32s	%10s	%10s	%6s" . $sep, "func", "run", "time", "%");
		foreach ($result as $fname => $info)
		{
			printf("%32s	%10d	%10.4f	%6.2f" . $sep, $fname, $count, $info, $info/$totalTime*100);
		}
	}
	
	private static function cmp_result($a, $b)
	{
		if ($a == $b)
		{
			return 0;
		}
		
		return $a < $b ? -1 : 1;
	}
}

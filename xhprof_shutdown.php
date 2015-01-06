<?php
/**
 How to use:
	require_once '/PATH_OF/xhprof_shutdown.php';
	$_SERVER['XHPROF_ROOT'] = '/opt/php-lib/xhprof/';
	$_SERVER['XHPROF_APP'] = 'blog';
	xhprof_enable(XHPROF_FLAGS_NO_BUILTINS + XHPROF_FLAGS_CPU + XHPROF_FLAGS_MEMORY);
*/

function xhprof_shutdown()
{
	$xhprof_data = xhprof_disable();
	
	$XHPROF_ROOT = "/vagrant/php-lib/xhprof-0.9.2/";
	if (!empty($_SERVER['XHPROF_ROOT']))
	{
		$XHPROF_ROOT = $_SERVER['XHPROF_ROOT'];
	}
	
	include_once $XHPROF_ROOT . "/xhprof_lib/utils/xhprof_lib.php";
	include_once $XHPROF_ROOT . "/xhprof_lib/utils/xhprof_runs.php";
	
	$app = '';
	if (!empty($_SERVER['XHPROF_APP']))
	{
		$app = $_SERVER['XHPROF_APP'];
	}
	
	$xhprof_runs = new XHProfRuns_Default();
	$run_id = $xhprof_runs->save_run($xhprof_data, $app . '.' . urlencode(substr($_SERVER['REQUEST_URI'], 0, 60)));
}

register_shutdown_function('xhprof_shutdown');

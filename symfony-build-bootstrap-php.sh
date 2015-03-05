#!/bin/bash

vendor/sensio/distribution-bundle/Sensio/Bundle/DistributionBundle/Resources/bin/build_bootstrap.php

php app/console cache:clear --no-warmup --no-optional-warmers --env=dev
php app/console cache:clear --no-warmup --no-optional-warmers --env=prod

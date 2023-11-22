#!/bin/bash

set -euo pipefail

reports_dir=reports
host_header="Host:weather-api"
rate="400"
duration="1800s"

echo "== stress test =="
echo "attacking with rate ${rate} and duration ${duration}.."
vegeta attack -rate=${rate} -header=${host_header} \
    -duration=${duration} -targets=targets.txt > ${reports_dir}/stress.gob

echo "generating report.."
vegeta report ${reports_dir}/stress.gob
echo "== done =="
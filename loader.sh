#!/bin/bash

set -euo pipefail

duration="120s"
host_header="Host:weather-api"
reports_dir=reports

echo "== max rps =="
for step in {1..20}; do
    rate="$(( ${step} * 50 ))"
    echo "doing iteration ${step} with rate: ${rate} and duration ${duration}"
    vegeta attack -keepalive=false -rate=${rate} -targets=targets.txt \
        -header=${host_header} -duration=${duration} > ${reports_dir}/max.${step}.gob
done

vegeta report ${reports_dir}/max.*.gob
echo "== done =="
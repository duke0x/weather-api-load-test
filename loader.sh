#!/bin/bash

set -euo pipefail

duration="120s"
host_header="Host:weather-api"
reports_dir=reports

rm -f ${reports_dir}/max.*.gob

echo "== max rps =="
for step in {1..6}; do
    rate="$(( ${step} * 25 ))"
    echo "doing iteration ${step} with rate: ${rate} and duration ${duration}"
    vegeta attack -keepalive=false -rate=${rate} -targets=targets.txt \
        -header=${host_header} -duration=${duration} > ${reports_dir}/max.${step}.gob
done

vegeta report ${reports_dir}/max.*.gob
echo "== done =="
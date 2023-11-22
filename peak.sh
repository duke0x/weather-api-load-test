#!/bin/bash

set -euo pipefail

host_header="Host:weather-api"
reports_dir=reports

warmup_rate="5"
warmup_duration="5s"
norm_rate="400"
norm_duration="300s"
peak_rate="1050"
peak_duration="60s"

echo "== peak test =="

echo "warming up with 5rps in 10 seconds.."
vegeta attack -rate=${warmup_rate} -header=${host_header} \
    -duration=${warmup_duration} -targets=targets.txt > ${reports_dir}/peak.warm_up.gob

echo "attacking with rate ${norm_rate} and duration ${norm_duration}.."
vegeta attack -rate=${norm_rate} -header=${host_header} \
    -duration=${norm_duration} -targets=targets.txt > ${reports_dir}/peak.1.gob

echo "attacking with peak rate ${peak_rate} and duration ${peak_duration}.."
vegeta attack -rate=${peak_rate} -header=${host_header} \
    -duration=${peak_duration} -targets=targets.txt > ${reports_dir}/peak.2.gob

echo "attacking with rate ${norm_rate} and duration ${norm_duration}.."
vegeta attack -rate=${norm_rate} -header=${host_header} \
    -duration=${norm_duration} -targets=targets.txt > ${reports_dir}/peak.3.gob

echo "generating report.."
vegeta report ${reports_dir}/peak.*.gob

echo "== done =="

#! /bin/bash
cd $(dirname ${BASH_SOURCE:-$0})
# cat urls | xargs -I{} -P1 -n1 -- curl -X POST 'https://web.archive.org/save/{}' -d 'url={}' -o /dev/null -w '%{url}: %{http_code}\n' -fs | awk '{print substr($0, 30)}' 2>&1 >>archive.log
# exit_code=${PIPESTATUS[1]}
# date >> archive.log
# echo ----- >> archive.log

exit_code=0

while read url; do
  echo -n "${url}: " >> archive.log
  curl -X POST "https://web.archive.org/save/${url}" -d "url=${url}" -o /dev/null -w '%{http_code}\n' -fs >> archive.log
  exit_code+=$?
  tail -n 1 -q archive.log
  sleep 60
done < urls
date >> archive.log
echo ----- >> archive.log

if [[ $exit_code -ne 0 ]]; then
  osascript -e 'display notification "archive error; information in ~/.scripts/cron/archive.log" with title "cron: error"'
else
  osascript -e 'display notification "archive completed; by ~/.scripts/cron/webarchive.sh" with title "cron: task completed"'
fi

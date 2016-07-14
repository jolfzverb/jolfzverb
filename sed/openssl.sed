#!/bin/sed -f
# This sed script translates openssl speed output(cout part of it) to table
# First column is test name(including size) second column is value. Columns are separated by "|"
/OpenSSL/d;
/built on/d;
/options:/d;
/compiler:/d;
/^The /d;
/^type/,/sign/{
  /sign/{
    b endtype;
  }
  /^type/{
    s/^type[[:space:]]*//;
    s/s[[:space:]]\+/s|/g;
    s/^/|/;
    h;
    d;
    b endtype;
  };
  {
    s/[[:space:]][[:space:]]\+/#/g;
    G;
    s/\n//;
    s/^\([^#]*\)#\([^#]*\)#\([^#]*\)#\([^#]*\)#\([^|]*\)|\([^|]*\)|\([^|]*\)|\([^|]*\)|\(.*\)/\1 \6 | \2\n\1 \7 | \3\n\1 \8 | \4\n#\1#\5#\9/
    s/^\([^#]*\)#\([^#]*\)#\([^#]*\)#\([^#|]*\)#\([^#|]*\)|\([^|#]*\)/\1\2 \5 | \3\n\2 \6 | \4/
  };
};
:endtype;
/sign/,/op\/s/{
  /op\/s/{
    b endsign
  }
  /sign/{
    d;
    b endtype;
  }
  {
    s/bits.*s  //
    s/(.*).*s.*s//
    s/  / /
    s/\(.*\)  \+\([^ ]\+\)  \+\([^ ]\+\)/\1 sign\/s | \2\n\1 verify\/s | \3/
  }
}
:endsign
/op\/s/,${
  /op\/s/d
  s/\(.*\)  \+\([^ ]\+\)  \+\([^ ]\+\)/\1 op\/s | \3/
}
s/  */ /g
s/^ *//g
s/\n */\n/g
#Tested on following output:

#OpenSSL 1.0.2g  1 Mar 2016
#built on: reproducible build, date unspecified
#options:bn(64,32) md2(int) rc4(ptr,char) des(idx,cisc,16,long) aes(partial) blowfish(ptr) 
#compiler: gcc -I. -I.. -I../include  -fPIC -DOPENSSL_PIC -DZLIB -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAVE_DLFCN_H -O2 -g2 -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector -Wformat-security -fmessage-length=0 -fno-semantic-interposition --param=ssp-buffer-size=4 -march=armv7-a -mtune=cortex-a8 -mlittle-endian -mfpu=neon -mfloat-abi=softfp -mthumb -Wp,-D__SOFTFP__ -Wa,-mimplicit-it=thumb -g -std=gnu99 -Wa,--noexecstack -fomit-frame-pointer -DTERMIO -DPURIFY -DSSL_FORBID_ENULL -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -Wall -fstack-protector -march=armv7-a -O3 -Wall
#The 'numbers' are in 1000s of bytes per second processed.
#type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes
#md2                557.95k     1182.99k     1647.79k     1826.13k     1889.62k
#mdc2              1423.99k     1652.52k     1732.78k     1752.75k     1752.71k
#md4               4468.50k    15037.27k    40627.71k    70715.39k    90365.95k
#md5               3677.75k    12297.73k    33319.85k    58034.18k    74137.60k
#hmac(md5)         4330.51k    13998.76k    36185.09k    60385.28k    74757.46k
#sha1              3159.74k     9069.46k    19911.68k    28134.40k    32129.02k
#rmd160            3114.20k     8890.03k    18855.85k    25964.89k    29485.74k
#rc4              44904.39k    51707.14k    53739.18k    54228.31k    54452.22k
#des cbc           9539.47k    10096.36k    10298.97k    10303.83k    10341.03k
#des ede3          3573.76k     3672.19k     3715.93k     3677.18k     3719.17k
#idea cbc             0.00         0.00         0.00         0.00         0.00 
#seed cbc         12070.86k    13363.16k    13690.71k    13745.83k    13841.75k
#rc2 cbc           7527.94k     7930.86k     8044.46k     8061.95k     8088.23k
#rc5-32/12 cbc        0.00         0.00         0.00         0.00         0.00 
#blowfish cbc     15403.64k    17003.48k    17452.80k    17542.49k    17629.18k
#cast cbc         14879.11k    16327.51k    16776.02k    16863.57k    16941.06k
#aes-128 cbc      14020.74k    15212.01k    15611.31k    15676.07k    15725.91k
#aes-192 cbc      12190.43k    13061.61k    13368.83k    13408.26k    13456.73k
#aes-256 cbc      10774.57k    11456.13k    11687.25k    11720.70k    11758.25k
#camellia-128 cbc    14591.88k    16384.60k    16968.62k    17074.86k    17170.43k
#camellia-192 cbc    11811.10k    12948.37k    13325.82k    13395.63k    13459.46k
#camellia-256 cbc    11812.45k    12965.46k    13328.98k    13389.48k    13459.46k
#sha256            2627.12k     5954.54k    10491.05k    12906.84k    13852.67k
#sha512             664.22k     2611.97k     3837.01k     5176.32k     5852.61k
#whirlpool          760.06k     1546.50k     2526.12k     2970.97k     3148.46k
#aes-128 ige      13778.97k    14975.15k    15368.28k    15425.88k    15436.89k
#aes-192 ige      12000.57k    12897.73k    13188.86k    13233.15k    13279.23k
#aes-256 ige      10627.50k    11327.25k    11552.77k    11578.37k    11621.72k
#ghash            11704.02k    12182.59k    12409.09k    12442.97k    12487.34k
#                  sign    verify    sign/s verify/s
#rsa  512 bits 0.002496s 0.000208s    400.7   4814.8
#rsa 1024 bits 0.012739s 0.000595s     78.5   1680.8
#rsa 2048 bits 0.076641s 0.001936s     13.0    516.6
#rsa 4096 bits 0.491429s 0.006752s      2.0    148.1
#                  sign    verify    sign/s verify/s
#dsa  512 bits 0.002109s 0.002453s    474.2    407.6
#dsa 1024 bits 0.005996s 0.007039s    166.8    142.1
#dsa 2048 bits 0.019627s 0.024237s     50.9     41.3
#                              sign    verify    sign/s verify/s
# 160 bit ecdsa (secp160r1)   0.0019s   0.0065s    513.3    154.7
# 192 bit ecdsa (nistp192)   0.0021s   0.0072s    467.8    138.9
# 224 bit ecdsa (nistp224)   0.0028s   0.0091s    361.3    109.4
# 256 bit ecdsa (nistp256)   0.0029s   0.0097s    348.0    102.9
# 384 bit ecdsa (nistp384)   0.0076s   0.0246s    132.2     40.7
# 521 bit ecdsa (nistp521)   0.0184s   0.0597s     54.3     16.7
# 163 bit ecdsa (nistk163)   0.0038s   0.0143s    266.1     70.1
# 233 bit ecdsa (nistk233)   0.0074s   0.0270s    134.4     37.1
# 283 bit ecdsa (nistk283)   0.0115s   0.0483s     86.7     20.7
# 409 bit ecdsa (nistk409)   0.0282s   0.1084s     35.4      9.2
# 571 bit ecdsa (nistk571)   0.0672s   0.2478s     14.9      4.0
# 163 bit ecdsa (nistb163)   0.0037s   0.0153s    270.4     65.3
# 233 bit ecdsa (nistb233)   0.0074s   0.0294s    135.8     34.1
# 283 bit ecdsa (nistb283)   0.0115s   0.0537s     86.6     18.6
# 409 bit ecdsa (nistb409)   0.0283s   0.1222s     35.4      8.2
# 571 bit ecdsa (nistb571)   0.0674s   0.2811s     14.8      3.6
#                              op      op/s
# 160 bit ecdh (secp160r1)   0.0055s    181.9
# 192 bit ecdh (nistp192)   0.0060s    167.6
# 224 bit ecdh (nistp224)   0.0077s    130.0
# 256 bit ecdh (nistp256)   0.0079s    126.9
# 384 bit ecdh (nistp384)   0.0204s     48.9
# 521 bit ecdh (nistp521)   0.0497s     20.1
# 163 bit ecdh (nistk163)   0.0071s    141.4
# 233 bit ecdh (nistk233)   0.0133s     75.1
# 283 bit ecdh (nistk283)   0.0240s     41.6
# 409 bit ecdh (nistk409)   0.0536s     18.6
# 571 bit ecdh (nistk571)   0.1236s      8.1
# 163 bit ecdh (nistb163)   0.0073s    136.8
# 233 bit ecdh (nistb233)   0.0146s     68.5
# 283 bit ecdh (nistb283)   0.0268s     37.4
# 409 bit ecdh (nistb409)   0.0610s     16.4
# 571 bit ecdh (nistb571)   0.1397s      7.2

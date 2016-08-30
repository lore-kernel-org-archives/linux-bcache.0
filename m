From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: clang doesn't like bcache-tools: libbcache.c:79:39: error: function
 definition is not allowed here
Date: Tue, 30 Aug 2016 10:42:29 +0200
Message-ID: <b8e1ee15-da4a-a5d3-3717-96b9286d9571@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:29894 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752805AbcH3InH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Aug 2016 04:43:07 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
Compilation of bcache-tools (branch: dev) fails due to:

> make -j3 
> clang -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags      "blkid uuid libnih"`   -c -o bcache.o bcache.c
> clang -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags      "blkid uuid libnih"`   -c -o bcache-assemble.o bcache-assemble.c
> clang -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags      "blkid uuid libnih"`   -c -o bcache-device.o bcache-device.c
> clang -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags      "blkid uuid libnih"`   -c -o bcache-format.o bcache-format.c
> clang -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags      "blkid uuid libnih"`   -c -o bcache-fs.o bcache-fs.c
> clang -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags      "blkid uuid libnih"`   -c -o bcache-run.o bcache-run.c
> bcache-fs.c:32:23: warning: unused variable 'fs' [-Wunused-variable]
>  struct bcache_handle fs = bcache_fs_open(args[0]);
>                       ^
> bcache-fs.c:48:23: warning: unused variable 'fs' [-Wunused-variable]
>  struct bcache_handle fs = bcache_fs_open(args[0]);
>                       ^
> bcache-fs.c:15:25: warning: unused function 'fill_fs' [-Wunused-function]
> static struct bcache_fs fill_fs(struct bcache_handle fs)
>                         ^
> 3 warnings generated.
> clang -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags      "blkid uuid libnih"`   -c -o bcache-key.o bcache-key.c
> clang -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags      "blkid uuid libnih"`   -c -o libbcache.o libbcache.c
> clang -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags      "blkid uuid libnih"`   -c -o crypto.o crypto.c
> clang -O2 -std=gnu99 -Wall -D_FILE_OFFSET_BITS=64 -I. `pkg-config --cflags      "blkid uuid libnih"`   -c -o util.o util.c
> libbcache.c:79:39: error: function definition is not allowed here
>    u64 min_size(unsigned bucket_size) {
>                                       ^
> libbcache.c:84:18: warning: implicit declaration of function 'min_size' is invalid in C99 [-Wimplicit-function-declaration]
>    if (i->size < min_size(block_size))
>                  ^
> libbcache.c:85:105: warning: format specifies type 'unsigned long long' but the argument has type 'int' [-Wformat]
>     do { fprintf(stderr, "cannot format %s, too small (%llu sectors, min %llu)" "\n", i->path, i->size, min_size(block_size)); exit(1); } while (0);
>                                                                          ~~~~                           ^~~~~~~~~~~~~~~~~~~~
>                                                                          %d
> 2 warnings and 1 error generated.
> make: *** [<builtin>: libbcache.o] Error 1


Regards,
Marcin

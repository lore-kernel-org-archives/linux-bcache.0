From: Ming Lin <mlin@kernel.org>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Wed, 15 Jul 2015 00:15:56 -0700
Message-ID: <1436944556.6520.5.camel@hasee>
References: <20150714005825.GA24027@kmo-pixel>
	 <1436940689.6520.1.camel@hasee>
	 <CAC7rs0sbg2ci6=niQ0X11AONZbr2AOYhRbxfDH_w4N4A7dyPLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34197 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbbGOHQB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 15 Jul 2015 03:16:01 -0400
In-Reply-To: <CAC7rs0sbg2ci6=niQ0X11AONZbr2AOYhRbxfDH_w4N4A7dyPLw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Tue, 2015-07-14 at 23:58 -0700, Kent Overstreet wrote:
> Can you strace it?

Strange. Now error message changed.

root@afa03:~# mount /dev/sdt /mnt/
mount: mount(2) failed: No such file or directory

strace:

execve("/bin/mount", ["mount", "/dev/sdt", "/mnt/"], [/* 17 vars */]) = 0
brk(0)                                  = 0x17c0000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe72a554000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=80188, ...}) = 0
mmap(NULL, 80188, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fe72a540000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libmount.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\216\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=274504, ...}) = 0
mmap(NULL, 2373920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe72a0ef000
mprotect(0x7fe72a130000, 2097152, PROT_NONE) = 0
mmap(0x7fe72a330000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x41000) = 0x7fe72a330000
mmap(0x7fe72a332000, 2336, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fe72a332000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\v\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1869392, ...}) = 0
mmap(NULL, 3972864, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe729d25000
mprotect(0x7fe729ee5000, 2097152, PROT_NONE) = 0
mmap(0x7fe72a0e5000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c0000) = 0x7fe72a0e5000
mmap(0x7fe72a0eb000, 16128, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fe72a0eb000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libblkid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\200\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=258376, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe72a53f000
mmap(NULL, 2357800, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe729ae5000
mprotect(0x7fe729b20000, 2097152, PROT_NONE) = 0
mmap(0x7fe729d20000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3b000) = 0x7fe729d20000
mmap(0x7fe729d24000, 2600, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fe729d24000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libselinux.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300[\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=138400, ...}) = 0
mmap(NULL, 2242448, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe7298c1000
mprotect(0x7fe7298e2000, 2093056, PROT_NONE) = 0
mmap(0x7fe729ae1000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x20000) = 0x7fe729ae1000
mmap(0x7fe729ae3000, 6032, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fe729ae3000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libuuid.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200\25\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=19000, ...}) = 0
mmap(NULL, 2113920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe7296bc000
mprotect(0x7fe7296c0000, 2093056, PROT_NONE) = 0
mmap(0x7fe7298bf000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7fe7298bf000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libpcre.so.3", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\26\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=444344, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe72a53e000
mmap(NULL, 2539880, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe72944f000
mprotect(0x7fe7294bb000, 2093056, PROT_NONE) = 0
mmap(0x7fe7296ba000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6b000) = 0x7fe7296ba000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\16\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=14592, ...}) = 0
mmap(NULL, 2109712, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe72924b000
mprotect(0x7fe72924e000, 2093056, PROT_NONE) = 0
mmap(0x7fe72944d000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7fe72944d000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340`\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=142080, ...}) = 0
mmap(NULL, 2217232, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fe72902d000
mprotect(0x7fe729045000, 2097152, PROT_NONE) = 0
mmap(0x7fe729245000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x18000) = 0x7fe729245000
mmap(0x7fe729247000, 13584, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fe729247000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe72a53d000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe72a53c000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe72a53a000
arch_prctl(ARCH_SET_FS, 0x7fe72a53a840) = 0
mprotect(0x7fe72a0e5000, 16384, PROT_READ) = 0
mprotect(0x7fe729245000, 4096, PROT_READ) = 0
mprotect(0x7fe72944d000, 4096, PROT_READ) = 0
mprotect(0x7fe7296ba000, 4096, PROT_READ) = 0
mprotect(0x7fe7298bf000, 4096, PROT_READ) = 0
mprotect(0x7fe729ae1000, 4096, PROT_READ) = 0
mprotect(0x7fe729d20000, 12288, PROT_READ) = 0
mprotect(0x7fe72a330000, 4096, PROT_READ) = 0
mprotect(0x608000, 4096, PROT_READ)     = 0
mprotect(0x7fe72a556000, 4096, PROT_READ) = 0
munmap(0x7fe72a540000, 80188)           = 0
set_tid_address(0x7fe72a53ab10)         = 3012
set_robust_list(0x7fe72a53ab20, 24)     = 0
rt_sigaction(SIGRTMIN, {0x7fe729032bb0, [], SA_RESTORER|SA_SIGINFO, 0x7fe72903dd10}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x7fe729032c40, [], SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7fe72903dd10}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
statfs("/sys/fs/selinux", 0x7ffe81f62fe0) = -1 ENOENT (No such file or directory)
statfs("/selinux", 0x7ffe81f62fe0)      = -1 ENOENT (No such file or directory)
brk(0)                                  = 0x17c0000
brk(0x17e1000)                          = 0x17e1000
open("/proc/filesystems", O_RDONLY)     = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe72a553000
read(3, "nodev\tsysfs\nnodev\trootfs\nnodev\tr"..., 1024) = 351
read(3, "", 1024)                       = 0
close(3)                                = 0
munmap(0x7fe72a553000, 4096)            = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1852464, ...}) = 0
mmap(NULL, 1852464, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fe72a375000
close(3)                                = 0
getuid()                                = 0
geteuid()                               = 0
lstat("/dev", {st_mode=S_IFDIR|0755, st_size=5260, ...}) = 0
lstat("/dev/sdt", {st_mode=S_IFBLK|0660, st_rdev=makedev(65, 48), ...}) = 0
stat("/dev/sdt", {st_mode=S_IFBLK|0660, st_rdev=makedev(65, 48), ...}) = 0
lstat("/mnt", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
access("/dev/sdt", F_OK)                = 0
open("/dev/sdt", O_RDONLY|O_CLOEXEC)    = 3
fadvise64(3, 0, 0, POSIX_FADV_RANDOM)   = 0
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(65, 48), ...}) = 0
uname({sys="Linux", node="msl-lab-afa03", ...}) = 0
ioctl(3, BLKGETSIZE64, 300000000000)    = 0
open("/sys/dev/block/65:48", O_RDONLY|O_CLOEXEC) = 4
openat(4, "dm/uuid", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
close(4)                                = 0
open("/sys/dev/block/65:48", O_RDONLY|O_CLOEXEC) = 4
newfstatat(4, "partition", 0x7ffe81f61a30, 0) = -1 ENOENT (No such file or directory)
openat(4, "dm/uuid", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
close(4)                                = 0
ioctl(3, CDROM_GET_CAPABILITY or SNDRV_SEQ_IOCTL_UNSUBSCRIBE_PORT, 0) = -1 EINVAL (Invalid argument)
lseek(3, 299999887360, SEEK_SET)        = 299999887360
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 64) = 64
lseek(3, 299999989760, SEEK_SET)        = 299999989760
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 256) = 256
lseek(3, 0, SEEK_SET)                   = 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 256) = 256
lseek(3, 4096, SEEK_SET)                = 4096
read(3, "\341\362\332\304P'\235\256\10\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\306\205s\366N\32E\312"..., 256) = 256
lseek(3, 299999999488, SEEK_SET)        = 299999999488
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512) = 512
lseek(3, 299999868416, SEEK_SET)        = 299999868416
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512) = 512
lseek(3, 299999998976, SEEK_SET)        = 299999998976
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 48) = 48
lseek(3, 299999967744, SEEK_SET)        = 299999967744
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999869440, SEEK_SET)        = 299999869440
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999868928, SEEK_SET)        = 299999868928
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999991808, SEEK_SET)        = 299999991808
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999795712, SEEK_SET)        = 299999795712
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999697408, SEEK_SET)        = 299999697408
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999654400, SEEK_SET)        = 299999654400
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999623680, SEEK_SET)        = 299999623680
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999533568, SEEK_SET)        = 299999533568
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999501312, SEEK_SET)        = 299999501312
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999492608, SEEK_SET)        = 299999492608
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999513088, SEEK_SET)        = 299999513088
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299998419456, SEEK_SET)        = 299998419456
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 24) = 24
lseek(3, 299999994368, SEEK_SET)        = 299999994368
read(3, "\0\0\0\0", 4)                  = 4
lseek(3, 4096, SEEK_SET)                = 4096
read(3, "\341\362\332\304P'\235\256\10\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\306\205s\366N\32E\312"..., 1024) = 1024
lseek(3, 4096, SEEK_SET)                = 4096
read(3, "\341\362\332\304P'\235\256\10\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\306\205s\366N\32E\312"..., 2256) = 2256
lseek(3, 299999995904, SEEK_SET)        = 299999995904
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
lseek(3, 0, SEEK_SET)                   = 0
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 1024, SEEK_SET)                = 1024
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 1048576, SEEK_SET)             = 1048576
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 3072, SEEK_SET)                = 3072
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 7168, SEEK_SET)                = 7168
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 15360, SEEK_SET)               = 15360
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 31744, SEEK_SET)               = 31744
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 64512, SEEK_SET)               = 64512
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
lseek(3, 0, SEEK_SET)                   = 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe728fec000
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 262144) = 262144
lseek(3, 393216, SEEK_SET)              = 393216
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 397312, SEEK_SET)              = 397312
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 401408, SEEK_SET)              = 401408
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 405504, SEEK_SET)              = 405504
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 409600, SEEK_SET)              = 409600
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 413696, SEEK_SET)              = 413696
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 417792, SEEK_SET)              = 417792
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 421888, SEEK_SET)              = 421888
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 425984, SEEK_SET)              = 425984
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 430080, SEEK_SET)              = 430080
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 434176, SEEK_SET)              = 434176
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 438272, SEEK_SET)              = 438272
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 442368, SEEK_SET)              = 442368
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 446464, SEEK_SET)              = 446464
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 450560, SEEK_SET)              = 450560
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 454656, SEEK_SET)              = 454656
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 458752, SEEK_SET)              = 458752
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 462848, SEEK_SET)              = 462848
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 466944, SEEK_SET)              = 466944
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 471040, SEEK_SET)              = 471040
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 475136, SEEK_SET)              = 475136
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 479232, SEEK_SET)              = 479232
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 483328, SEEK_SET)              = 483328
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 487424, SEEK_SET)              = 487424
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 491520, SEEK_SET)              = 491520
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 495616, SEEK_SET)              = 495616
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 499712, SEEK_SET)              = 499712
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 503808, SEEK_SET)              = 503808
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 507904, SEEK_SET)              = 507904
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 512000, SEEK_SET)              = 512000
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 516096, SEEK_SET)              = 516096
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 520192, SEEK_SET)              = 520192
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 41) = 41
lseek(3, 262144, SEEK_SET)              = 262144
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1377) = 1377
lseek(3, 2097152, SEEK_SET)             = 2097152
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
ioctl(3, BLKSSZGET, 512)                = 0
close(3)                                = 0
munmap(0x7fe728fec000, 266240)          = 0
stat("/sbin/mount.bcache", 0x7ffe81f61d60) = -1 ENOENT (No such file or directory)
stat("/sbin/fs.d/mount.bcache", 0x7ffe81f61d60) = -1 ENOENT (No such file or directory)
stat("/sbin/fs/mount.bcache", 0x7ffe81f61d60) = -1 ENOENT (No such file or directory)
getuid()                                = 0
geteuid()                               = 0
getgid()                                = 0
getegid()                               = 0
prctl(PR_GET_DUMPABLE)                  = 1
getuid()                                = 0
geteuid()                               = 0
getgid()                                = 0
getegid()                               = 0
prctl(PR_GET_DUMPABLE)                  = 1
stat("/run", {st_mode=S_IFDIR|0755, st_size=760, ...}) = 0
lstat("/etc/mtab", {st_mode=S_IFLNK|0777, st_size=12, ...}) = 0
lstat("/run/mount/utab", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
open("/run/mount/utab", O_RDWR|O_CREAT|O_CLOEXEC, 0644) = 3
close(3)                                = 0
mount("/dev/sdt", "/mnt", "bcache", MS_MGC_VAL, NULL) = -1 ENOENT (No such file or directory)
lstat("/mnt", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/mnt", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat("/dev/sdt", {st_mode=S_IFBLK|0660, st_rdev=makedev(65, 48), ...}) = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2570, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe72a553000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2570
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7fe72a553000, 4096)            = 0
open("/usr/share/locale/en_US/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "mount: ", 7mount: )                  = 7
write(2, "mount(2) failed", 15mount(2) failed)         = 15
write(2, ": ", 2: )                       = 2
open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "No such file or directory\n", 26No such file or directory
) = 26
close(1)                                = 0
close(2)                                = 0
exit_group(32)                          = ?
+++ exited with 32 +++

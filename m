From: Brad Campbell <lists2009-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: Bcache explodes when trying to attach
Date: Mon, 17 Oct 2011 21:52:12 +0800
Message-ID: <4E9C330C.6090801@fnarfbargle.com>
References: <4E991D90.1040008@fnarfbargle.com>	<4E9983B1.9060803@fnarfbargle.com>	<CAC7rs0sm5BgEawAZYjJjnrqAgyK+D96vmpn=1NEQuTJGk+BgAg@mail.gmail.com>	<4E9A6866.70803@fnarfbargle.com> <CAC7rs0vCA_j9O8-=Xouu0qH+yQxg8zYTP4K802TFJ2sm46OLfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0vCA_j9O8-=Xouu0qH+yQxg8zYTP4K802TFJ2sm46OLfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 16/10/11 13:38, Kent Overstreet wrote:
> Ah, that's good to know. In that case - if you wanted to try it
> without md - I don't _expect_ any issues, but then that's the point :)
>
> Performance numbers would be awesome, if you got that far...

I've bumped up against another roadblock that puzzles me. Any insight 
would be much appreciated.

qemu fails to read from the device properly if it's opened with O_DIRECT 
on a bcache based block device.

If I just use ext4 on a normal partition it works fine.

Here are a couple of straces. Command lines are identical s/raid10/mnt/ 
for the second one. Both partitions contents are bit for bit identical 
rsync clones. Both ext4 and mounted with the same options. These were 
captured less than a minute apart, so for all intents and purposes they 
represent precisely the failure I'm seeing.

Failing on /dev/bcache0

29169 open("/raid10/VM/ubuntu_10.04LTS-zimbra.qcow2", 
O_RDONLY|O_NONBLOCK) = 9
29169 ioctl(9, CDROM_DRIVE_STATUS, 0x7fffffff) = -1 ENOTTY 
(Inappropriate ioctl for device)
29169 close(9)                          = 0
29169 open("/raid10/VM/ubuntu_10.04LTS-zimbra.qcow2", 
O_RDONLY|O_NONBLOCK) = 9
29169 ioctl(9, FDGETPRM, 0x7fff9a7cb9e0) = -1 ENOTTY (Inappropriate 
ioctl for device)
29169 close(9)                          = 0
29169 stat("/raid10/VM/ubuntu_10.04LTS-zimbra.qcow2", 
{st_mode=S_IFREG|0666, st_size=2058485760, ...}) = 0
29169 open("/raid10/VM/ubuntu_10.04LTS-zimbra.qcow2", 
O_RDWR|O_DIRECT|O_CLOEXEC) = 9
29169 mmap(NULL, 139264, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa3dea33000
29169 rt_sigprocmask(SIG_BLOCK, [USR2], NULL, 8) = 0
29169 signalfd(4294967295, [USR2], 8)   = 10
29169 fcntl(10, F_GETFD)                = 0
29169 fcntl(10, F_SETFD, FD_CLOEXEC)    = 0
29169 fcntl(10, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
29169 lseek(9, 0, SEEK_END)             = 2058485760
29169 pread(9, 0x7fa3dea34000, 512, 0)  = -1 EINVAL (Invalid argument)
29169 close(9)                          = 0

Working on /dev/sdg4

16269 open("/mnt/VM/ubuntu_10.04LTS-zimbra.qcow2", O_RDONLY|O_NONBLOCK) = 9
16269 ioctl(9, CDROM_DRIVE_STATUS, 0x7fffffff) = -1 ENOTTY 
(Inappropriate ioctl for device)
16269 close(9)                          = 0
16269 open("/mnt/VM/ubuntu_10.04LTS-zimbra.qcow2", O_RDONLY|O_NONBLOCK) = 9
16269 ioctl(9, FDGETPRM, 0x7fff8a3b1a40) = -1 ENOTTY (Inappropriate 
ioctl for device)
16269 close(9)                          = 0
16269 stat("/mnt/VM/ubuntu_10.04LTS-zimbra.qcow2", 
{st_mode=S_IFREG|0664, st_size=2058485760, ...}) = 0
16269 open("/mnt/VM/ubuntu_10.04LTS-zimbra.qcow2", 
O_RDWR|O_DIRECT|O_CLOEXEC) = 9
16269 mmap(NULL, 139264, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fc626a46000
16269 rt_sigprocmask(SIG_BLOCK, [USR2], NULL, 8) = 0
16269 signalfd(4294967295, [USR2], 8)   = 10
16269 fcntl(10, F_GETFD)                = 0
16269 fcntl(10, F_SETFD, FD_CLOEXEC)    = 0
16269 fcntl(10, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
16269 lseek(9, 0, SEEK_END)             = 2058485760
16269 pread(9, 
"QFI\373\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\20\0\0\0\5\0\0\0\0"..., 
512, 0) = 512
16269 pread(9, 
"\200\0\0\0\0\4\0\0\200\0\0\0\4&\0\0\200\0\0\0\4\205\0\0\0\0\0\0\0\0\0\0"..., 
512, 196608) = 512

From: marcin@mejor.pl
Subject: Re: [bcachefs tree] Can't load bcache module second time
Date: Sat, 06 Aug 2016 14:20:12 +0200
Message-ID: <36b48a9e235db2188b5063ebe6d23e4a@mejor.pl>
References: <af228b9a-b5ac-814e-efe5-347d6780d0ab@mejor.pl>
 <alpine.LRH.2.11.1608051243330.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:10026 "EHLO jowisz.mejor.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbcHFVCS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sat, 6 Aug 2016 17:02:18 -0400
In-Reply-To: <alpine.LRH.2.11.1608051243330.10662@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Hi!

W dniu 2016-08-05 21:47, Eric Wheeler napisał(a):
> On Fri, 5 Aug 2016, Marcin Mirosław wrote:
> 
>> Hi!
>> Kernel is on commit 1c99b8fdce303e0961ee982919c890bf156ed775.
>> Host is freshly rebooted.
>> # grep bcache /proc/modules
>> # modprobe bcache && rmmod bcache && modprobe bcache
>> modprobe: ERROR: could not insert 'bcache': Cannot allocate memory
>> 
>> In dmesg I've got:
>> > Aug  5 15:39:14 localhost kernel: [  249.911487] WARNING: CPU: 3 PID: 17892 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x5d/0x70
>> > Aug  5 15:39:14 localhost kernel: [  249.911490] sysfs: cannot create duplicate filename '/devices/virtual/bcache'
> 
> Hmm, it looks like something in sysfs might not get unregistered at 
> module
> unload time, so reloading it causes the warning.
> 
> Are you using bcache or bcachefs?  I don't see bch_fs_init() in 4.7:

> http://lxr.free-electrons.com/ident?i=bch_fs_init
> 	< empty >
> 
> If bcachefs, please update the subject when you reply.

$ grep -R  bch_fs_init drivers/md/bcache/*.{c,h}
drivers/md/bcache/fs.c:int __init bch_fs_init(void)
drivers/md/bcache/super.c:          bch_fs_init() ||
drivers/md/bcache/bcache.h:int bch_fs_init(void);

I'm little confused. Module name is "bcache" and I used it in subject 
because I couldn't load such module. I think that this module supports 
both bcache (cache device) and bcachefs. And yes, I'm using kernel tree 
with bcachefs support:)

Marcin

From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: RE: Missing /sys/fs/bcache
Date: Tue, 12 Mar 2013 01:42:43 +0000
Message-ID: <93462A6BCE1CD840B94554FBBEE4C936032CBC0CF4@THHS2E12BE8X.hostedservice2.net>
References: <CAEHxbC0RoOBHfjBzot2SQ3MNO874vEt3TzGsS0E1gecLZxc_vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEHxbC0RoOBHfjBzot2SQ3MNO874vEt3TzGsS0E1gecLZxc_vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Zapp <greg.zapp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Greg,

I may well be wrong but I think bcache requires the patched kernel to run.  I don't think it can simply be compiled as a loadable module.

I have not used the latest versions so I could well be wrong here.

If building a modules is supported now and you have compiled a module for bcache then maybe it is not loaded?

Check the output of 'lsmod' for a bcache entry.

If it is not listed then you can probably load the module with:

insmod <module name>

Like I said above tho, to my knowledge you have to patch the kernel.

I am sure someone more knowledgeable will be around soon enough to give you a proper answer. (They are usually pretty decent at answering)

Hope this helps a bit,

James

-----Original Message-----
From: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Greg Zapp
Sent: 12 March 2013 01:36
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Missing /sys/fs/bcache

Hello All,

I have decided to just test the bcache-3.2 branch for now without patching the Ubuntu Kernel.  I've built and installed it successfully but for some reason /sys/fs/bcache is not present:
root@server:~# uname -a
Linux server.local 3.2.28+ #1 SMP Tue Mar 12 01:28:27 NZDT 2013 x86_64
x86_64 x86_64 GNU/Linux
root@server:~# ls /sys/fs
cgroup  ecryptfs  ext4  fuse

I'm sure I've done something wrong, would anybody be able to point me in the right direction?

Thanks,
   Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: software raid and bcache
Date: Wed, 3 Jul 2013 16:41:14 +0000 (UTC)
Message-ID: <kr1k7a$v4m$1@ger.gmane.org>
References: <CACaajQuSFAu9i-EzNfEnfDpCwzAf4OHR8vxk5ZtjaaRS75Tz7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, 03 Jul 2013 19:43:55 +0400, Vasiliy Tolstov wrote:
> Hello. I'm newbie with bcache and stuck at drive configuration.
> Now i have 1 sata 3Tb disk and one 240Gb ssd eMLC disk. I want to
> create from 1 sata disk raid1 with missing 1 drive (i want to able to
> sync pre failed sata disk with new by remove ssd disk and add sata)
> 
> What steps i need to do?

Hello,

You could use `blocks to-lvm`[1] to convert your large disk to lvm,
and then `blocks to-bcache` to convert the lvm volume to bcache.
The lvm conversion will allow you to migrate the data off the
prefailed disk later, either by moving it (pvmove) or by converting
to raid1 (lvconvert).

The blocks README should guide you through converting.  Right now it
doesn't include instructions on attaching the slow backing device to
the SSD cache device, I'll see about adding that, or you can refer
to the ATTACHING section of [2].

[1] https://github.com/g2p/blocks
[2] http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt?h=bcache-dev

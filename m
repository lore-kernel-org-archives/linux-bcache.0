From: Yuxuan Shui <yshuiv7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Bcache causes data lose.
Date: Thu, 7 Nov 2013 10:39:39 +0000
Message-ID: <CAMJW5=23t=jQRObnB5NHU8hTRBg6bCyW2m0+HCgtS8dxd82rRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I'm trying bcache for the past two days. And I observed several data
corruptions.

This happens with both writeback and writethrough cache. After reboot,
I saw my filesystem corrupted. With writeback cache, there's no way to
recover it. With writethrough cache, after I detach the backing device
from the cache set, I can mount my filesystem again. So I think this
is cleanly a bcache bug.

I don't know if above information is enough, if you need to anything,
I'll do my best to provide

Regards,
Yuxuan Shui.

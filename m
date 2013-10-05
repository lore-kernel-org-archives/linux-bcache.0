From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: bcache oops with 3.12-rc3
Date: Sat, 05 Oct 2013 23:51:02 +0200
Message-ID: <525089C6.6070502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hello,
I have this reproducible crash soon after booting:
http://i.imgur.com/ynDFOI2.jpg

Partial transcript:
bch_insert_data
closure_queue
request_write
cached_dev_make_request

bcache is stacked on top of LVM.

I've confirmed it with this vanilla kernel:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-rc3-saucy/

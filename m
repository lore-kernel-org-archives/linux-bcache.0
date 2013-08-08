From: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Replacing the caching device (SSD) of a bcache set
Date: Thu, 8 Aug 2013 14:17:24 +0200
Message-ID: <CAPBO7TbPW5thQt04kUm6gzHqAJna+2pvKU5rnwLVGc7DdBdMvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

I am running a root file system (/) in a bcache set (/dev/sda3 as the
backing device and /dev/sdb -the SSD- as the caching device).

I want to replace the caching device with another hardware.

The question is, which is the best procedure to replace it? I was thinking
about:

- turn off computer.
- replace SSD with the new one.
- turn on computer.

It seems to me very simple, perhaps too much. Does it need any other
step? Reattaching?



--
--
Salutacions...Josep
--

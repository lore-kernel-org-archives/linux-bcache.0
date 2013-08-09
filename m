From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Replacing the caching device (SSD) of a bcache set
Date: Thu, 8 Aug 2013 17:18:44 -0700
Message-ID: <20130809001844.GD15409@kmo-pixel>
References: <CAPBO7TbPW5thQt04kUm6gzHqAJna+2pvKU5rnwLVGc7DdBdMvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPBO7TbPW5thQt04kUm6gzHqAJna+2pvKU5rnwLVGc7DdBdMvA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Aug 08, 2013 at 02:17:24PM +0200, Josep Lladonosa wrote:
> Hello,
> 
> I am running a root file system (/) in a bcache set (/dev/sda3 as the
> backing device and /dev/sdb -the SSD- as the caching device).
> 
> I want to replace the caching device with another hardware.
> 
> The question is, which is the best procedure to replace it? I was thinking
> about:
> 
> - turn off computer.
> - replace SSD with the new one.
> - turn on computer.
> 
> It seems to me very simple, perhaps too much. Does it need any other
> step? Reattaching?

Detach the bcache device from the cache set first - _definitely_ do that
first if you're using it in writeback mode

echo 1 > /sys/block/bcache0/bcache/detach

Unregistering the cache set detaches it from every attached device too:
echo 1 > /sys/fs/bcache/<cache set>/unregister

From: Josep Lladonosa <jlladono-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Replacing the caching device (SSD) of a bcache set
Date: Sun, 11 Aug 2013 11:28:03 +0200
Message-ID: <CAPBO7TYh36a1ON=4zT6qvwQYAwsOy5KAu0qQLNMtLP9+ySdoMA@mail.gmail.com>
References: <CAPBO7TbPW5thQt04kUm6gzHqAJna+2pvKU5rnwLVGc7DdBdMvA@mail.gmail.com>
	<20130809002550.GE15409@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130809002550.GE15409@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 9 August 2013 02:25, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org> wrote:
> On Thu, Aug 08, 2013 at 02:17:24PM +0200, Josep Lladonosa wrote:
>> Hello,
>>
>> I am running a root file system (/) in a bcache set (/dev/sda3 as the
>> backing device and /dev/sdb -the SSD- as the caching device).
>>
>> I want to replace the caching device with another hardware.
>>
>> The question is, which is the best procedure to replace it? I was thinking
>> about:
>>
>> - turn off computer.
>> - replace SSD with the new one.
>> - turn on computer.
>>
>> It seems to me very simple, perhaps too much. Does it need any other
>> step? Reattaching?
>
> Oh, for reattaching - after you boot up with the new SSD, you'll format
> it and register it, then reattach
>
> ls /sys/fs/bcache to get the new cache set UUID
>
> echo <uuid> /sys/block/bcache0/bcache/attach


Hello,

Thanks to eveybody. All working now.

Just a comment. I find that with kernel 3.11.0-rc4 hard disk writes
are teeeeeerribly slow (for example when installing a deb package, for
example, a new kernel. It runs, but very slow comparing to a system
running without bcache.

Josep


-- 
--
Salutacions...Josep
--

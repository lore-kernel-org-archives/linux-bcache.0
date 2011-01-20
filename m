From: Cory Coager <ccoager-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: support for physical ramdisk
Date: Wed, 19 Jan 2011 19:59:55 -0500
Message-ID: <4D37890B.3060808@gmail.com>
References: <4D377D66.5020609@gmail.com> <AANLkTik30_V_bWGsvoUQw-5-W7URK1tSTDSfcTa8LayX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik30_V_bWGsvoUQw-5-W7URK1tSTDSfcTa8LayX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I was hoping to enable write back with the use of a battery backed 
ramdisk.  I'm simply substituting the SSD for a physical ramdisk.  The 
ramdisk would outperform the SSD and would probably be safer during 
power loss than a SSD (assuming the battery is in good condition).

On 01/19/2011 07:22 PM, Kent Overstreet wrote:
> It'd function, but performance would be worse than just using the
> pagecache, bcache does a whole lot of extra work to get around the
> limitations of SSDs and the pagecache is blazing fast. Why would you
> want to do that?
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

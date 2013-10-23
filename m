From: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Subject: RE: bcache-tools and bcache support in other linux packages
Date: Tue, 22 Oct 2013 18:36:34 -0700
Message-ID: <0cc401cecf90$51437a20$f3ca6e60$@acm.org>
References: <20131018092234.GA18159@lazy.lzy>	<CE86CB5C.BB96%rolf@rolffokkens.nl> <CAPVzhpwGvP9RK9bEmNLLvy5qM8ejHcoDkeFU3aksdJq9BE0u6g@mail.gmail.com> <52623BE9.5070507@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52623BE9.5070507-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Content-Language: en-us
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Rolf Fokkens' <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>, 'Reartes Guillermo' <rtguille-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Development discussions related to Fedora' <devel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
Cc: 'Piergiorgio Sartor' <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> From: Rolf Fokkens
> Sent: Saturday, October 19, 2013 1:00 AM
>
> There's also an explanation in the document why it isn't enabled by
default:
> "|Defaults to off, since SATA TRIM is an unqueued command (and thus
> slow)."

Is there any way to TRIM all the empty space in bulk occasionally at off
hours (like fstrim), or if you don't enable TRIM the only way to clean up
would be to occasionally disable the cache, do a secure erase (or
something), and then recreate/add it back?

Thanks.
 

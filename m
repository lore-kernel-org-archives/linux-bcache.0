From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: Data corruption with bcache in 3.11
Date: Fri, 20 Sep 2013 21:33:19 +0200
Message-ID: <523CA2FF.4090102@rolffokkens.nl>
References: <20130920023501.GJ17891@kmo-pixel> <523BF3EB.7050709@rolffokkens.nl> <CALJ65zkj2U-Kr_EBx7RJETqW2jQmWxsr0QmZspHU3H+jDts3tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALJ65zkj2U-Kr_EBx7RJETqW2jQmWxsr0QmZspHU3H+jDts3tQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 09/20/2013 09:44 AM, Kent Overstreet wrote:
> If you weren't seeing it before, don't worry about it. Normal setups
> with the usual 4k block size won't ever see this.
I wouldn't mind helping to reproduce other issues as well, like the 
iozone related issues and the "bcache hangs" issue. I actually tried, 
but bcache worked just fine.

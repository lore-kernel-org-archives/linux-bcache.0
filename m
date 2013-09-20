From: Zachary Palmer <zep_bcache-J5qI5MFTcs8@public.gmane.org>
Subject: Re: Data corruption with bcache in 3.11
Date: Fri, 20 Sep 2013 16:45:38 -0400
Message-ID: <523CB3F2.90809@bahj.com>
References: <20130920023501.GJ17891@kmo-pixel> <523BF3EB.7050709@rolffokkens.nl> <CALJ65zkj2U-Kr_EBx7RJETqW2jQmWxsr0QmZspHU3H+jDts3tQ@mail.gmail.com> <523CA2FF.4090102@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <523CA2FF.4090102-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 09/20/2013 09:44 AM, Kent Overstreet wrote:
> If you weren't seeing it before, don't worry about it. Normal setups
> with the usual 4k block size won't ever see this.
Fascinating.  That might have been my problem; my block size is 
currently 512.  (Is that ill-advised?)  I'm currently running a kernel 
built from the 3.11 corruption fix branch and I have no problems so 
far.  I'll report back in a few days; that's how long it usually took to 
start corrupting things and segfaulting the world. :)

Thanks,

Zach

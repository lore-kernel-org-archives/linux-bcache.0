From: C Sights <csights-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Subject: Re: bcache compared to more RAM
Date: Thu, 16 Aug 2012 20:31:37 -0500
Message-ID: <201208162031.37525.csights@fastmail.fm>
References: <201208150630.36861.csights@fastmail.fm> <CA+res+RTJDPKS02Pou8Pui0qnCX1=L6juS1k5mYJ-bp-Qd+JmA@mail.gmail.com> <502D1DE0.8090300@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502D1DE0.8090300-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> >>> Under what circumstance would you intend to actually use ram backed
> >>> bcache?

A laptop with a fully charged battery?  :)

Thanks for the flexible I/O tester idea.  Would it be possible to mount bcache 
to a file stored in /dev/shm? 

Mostly I am curious as to whether bcache would do better than Linux's other 
RAM based caching of filesystem data.

Thanks for the ideas and the code!
Chad.

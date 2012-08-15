From: John McCabe-Dansted <gmatht-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache compared to more RAM
Date: Wed, 15 Aug 2012 19:51:56 +0800
Message-ID: <CAA-P7fUiZFKnfyAEEQtB+23W74VGK-TU4o0WX2RF_gbn5Gaq=Q@mail.gmail.com>
References: <201208150630.36861.csights@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201208150630.36861.csights-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: C Sights <csights-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Aug 15, 2012 at 7:30 PM, C Sights <csights-97jfqw80gc6171pxa8y+qA@public.gmane.org> wrote:
> Hi all,
>    Has anyone tried creating a bcache device in RAM and benchmarking
> performance of that versus just allowing that RAM to be used as file system
> buffers?

I doubt it; bcache is designed to use non-volatile flash memory rather
than ram.

If the filesystem is readonly, I imagine that using RAM for bcache
would lead to worse performance as it would just add overhead. If the
filesystem is read-write then it might lead to better performance but
would also lead to the file-system being trashed on if unexpected
power loss occurs.

Under what circumstance would you intend to actually use ram backed bcache?

-- 
John C. McCabe-Dansted

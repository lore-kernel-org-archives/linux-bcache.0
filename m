From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [GIT] Bcache version 12
Date: Thu, 6 Oct 2011 19:58:08 +0200
Message-ID: <20111006175808.GA9886@atrey.karlin.mff.cuni.cz>
References: <20110910064531.GA32536@moria> <CAOJsxLFPODubVEB3Tjg54C7jDKM8H-RCM_u5kvO1D0kKyjUYXQ@mail.gmail.com> <20110921025545.GB5521@moria> <CAOJsxLHQdf-+HuwVsQtF26oY_oJf3BsVdDi3NyJDi7F0eD03Gw@mail.gmail.com> <CAOJsxLGWoGqdv=tdBwWjM9-MD_Qm3ibMSGpp1j-tQLjMW-b-0A@mail.gmail.com> <20110921055708.GB6601@moria>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110921055708.GB6601@moria>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi!

> It can cache filesystem metadata - it can cache anything.
> 
> Because bcache has its own superblock (much like md), it can guarantee
> that bcache devices are consistent; this is particularly important if
> you want to do writeback caching. You really don't want to accidently
> mount a filesystem that you were doing writeback caching on without the
> ache - bcache makes it impossible to do so accidently.
> 
> Is any of that useful?

I guess some kind of benchmark would be nice....? I don't know what
fair workload for this is. System bootup? Kernel compile after reboot?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

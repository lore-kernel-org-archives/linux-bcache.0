From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] Generic rb tree code
Date: Tue, 29 May 2012 14:28:44 +0900
Message-ID: <20120529052844.GB17366@google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
 <20120528232246.GC20954@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120529033032.GB10175@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120529033032.GB10175-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello, Kent.

On Mon, May 28, 2012 at 11:30:32PM -0400, Kent Overstreet wrote:
> > Modeled after spinlock code how?  AFAICS, spinlock code doesn't
> > present inline and !inline versions to users. 
> 
> That probably wasn't intended, but it's how it works out.
> __raw_spin_lock() and all the variants are defined as inline functions,
> and then depending on whether CONFIG_INLINE_BLAH is enabled
> _raw_spin_lock_blah() is defined to __raw_spin_lock_blah(), otherwise
> _raw_spin_lock_blah() is a wrapper in a .c file.
> 
> But the end result is that the inline versions are also available.

Doesn't matter.  Nobody outside spinlock implementation proper should
be using them.

> > All the current users
> > are inline anyway, why not just provide inlined versions and worry
> > about whether inlining is beneifical in a separate patch?
> 
> Yeah, possible. I think it's only going to be an issue for rb_search()
> in practice (since rb_search needs the stack allocated search argument),
> should probably just drop the inline version of rb_insert().

As long as there's single version of the thing....

Thanks.

-- 
tejun

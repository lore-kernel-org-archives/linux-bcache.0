From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] block: convert elevator to generic rb tree code
Date: Tue, 29 May 2012 02:57:58 -0400
Message-ID: <20120529065758.GE10175@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
 <1337979461-19654-4-git-send-email-koverstreet@google.com>
 <20120528231717.GB20954@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120529032502.GA10175@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120529052458.GA17366@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120529052458.GA17366-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, May 29, 2012 at 02:24:58PM +0900, Tejun Heo wrote:
> > So in practice there's no extra stack usage. Whether this is an
> > optimization we want to depend I'm not going to say; I suspect it's
> > pretty safe w.r.t. the optimizer but it's definitely sketchy and if at
> > some point someone came along and switched it to the uninline version
> > we'd have problems.
> 
> I don't think we can depend on that.  Note that compiler may as well
> decide not to inline an inline function (e.g. if it sees many calling
> instances).  Depending on such behavior is way too fragile.

Bah, I forgot about the compiler uninlining stuff. There's
__always_inline, but... yeah, I agree, too dangerous.

> > So we might want to leave this one open coded. Which would make me sad,
> > but I can't think of a sane way of implementing generic rb_search() that
> > doesn't require passing it a type t to compare against.
> 
> I don't know either.  Open coding isn't the end of the world but I
> suspect a lot of data structures which go on rbtree wouldn't be stack
> friendly, so having common helper which can't handle that might not be
> too helpful.

There's > 100 users in the kernel, I have no clue what the average size
of the containing struct is.

I think I'm gonna split rb_search() out into its own patch, as
rb_insert() fortunately doesn't have this problem.

I'm starting to think the sanest solution is a macro (not quite my
original RB_SEARCH() macro, though).

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] Generic rb tree code
Date: Tue, 29 May 2012 08:22:46 +0900
Message-ID: <20120528232246.GC20954@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337979461-19654-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, May 25, 2012 at 01:57:38PM -0700, Kent Overstreet wrote:
> Right now, users of the rb tree code have to open code their own search and
> insert functions. This provides generic versions that you pass a comparison
> function to.
> 
> I highly doubt the extra function calls are going to have a measurable
> performance impact in practice - the pointer chasing is going to dominate. I
> did provide inline versions just in case, though - it's modelled after the
> spinlock code.

Modeled after spinlock code how?  AFAICS, spinlock code doesn't
present inline and !inline versions to users.  All the current users
are inline anyway, why not just provide inlined versions and worry
about whether inlining is beneifical in a separate patch?

Thanks.

-- 
tejun

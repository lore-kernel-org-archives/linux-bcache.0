From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] block: convert elevator to generic rb tree code
Date: Tue, 29 May 2012 08:17:17 +0900
Message-ID: <20120528231717.GB20954@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
 <1337979461-19654-4-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337979461-19654-4-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, May 25, 2012 at 01:57:41PM -0700, Kent Overstreet wrote:
> Change-Id: I676968e201f0de9a0d0a7813e2fcc6873343e8c3
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

You know what I was gonna complain about here, right?  :)

>  struct request *elv_rb_find(struct rb_root *root, sector_t sector)
>  {
> -	struct rb_node *n = root->rb_node;
> -	struct request *rq;
> -
> -	while (n) {
> -		rq = rb_entry(n, struct request, rb_node);
> +	struct request search = { .__sector = sector };

This is dangerous.  You can't put things like struct request on stack.
It might look like it's working ok on the tested setup but archs
differ in stack pressure and more importantly people may add
arbitrarily sized fields, including debugging stuff, to struct
request.  So, no, please don't do that.

Thanks.

-- 
tejun

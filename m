From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] rbtree: Add rb_insert(), rb_search(), etc.
Date: Tue, 29 May 2012 08:35:10 +0900
Message-ID: <20120528233510.GD20954@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
 <1337979461-19654-2-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337979461-19654-2-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello, Kent.

Please cc akpm.

On Fri, May 25, 2012 at 01:57:39PM -0700, Kent Overstreet wrote:
> Change-Id: I072d94a42b75454aa62be849c724980d27523b08
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Same complaints.

And function comments please.

> +static inline int _rb_insert(struct rb_root *root,
> +			     struct rb_node *new,
> +			     rb_cmp_t cmp)
> +{
> +	struct rb_node **n = &root->rb_node, *parent = NULL;
> +	int res;
> +
> +	while (*n) {
> +		parent = *n;
> +		res = cmp(new, *n);
> +		if (!res)
> +			return -1;

-EINVAL?

> +		n = res < 0
> +			? &(*n)->rb_left
> +			: &(*n)->rb_right;

I don't know.  I'm finding this formatting rather weird.  If ?: has to
be used and line has to break, how about the following?

		n = res < 0 ? A
			    : B;

Or how about using good'ol if else?

	if (res < 0)
		n = A;
	else if (res > 0)
		n = B;
	else
		return -EINVAL;

> +	}
> +
> +	rb_link_node(new, parent, n);
> +	rb_insert_color(new, root);
> +	return 0;
> +}
> +
> +static inline void _rb_insert_allow_dup(struct rb_root *root,
> +				       struct rb_node *new,
> +				       rb_cmp_t cmp)
> +{
> +	struct rb_node **n = &root->rb_node, *parent = NULL;
> +
> +	while (*n) {
> +		parent = *n;
> +		n = cmp(new, *n) < 0
> +			? &(*n)->rb_left
> +			: &(*n)->rb_right;

Ditto.

> +	}
> +
> +	rb_link_node(new, parent, n);
> +	rb_insert_color(new, root);
> +}
> +
> +static inline struct rb_node *_rb_search(struct rb_root *root,
> +					 struct rb_node *search,
> +					 rb_cmp_t cmp)
> +{
> +	struct rb_node *n = root->rb_node;
> +
> +	while (n) {
> +		int res = cmp(search, n);
> +		if (!res)
> +			return n;
> +
> +		n = res < 0
> +			? n->rb_left
> +			: n->rb_right;
> +	}
> +
> +	return NULL;
> +}
> +
> +static inline struct rb_node *_rb_greater(struct rb_root *root,
> +					  struct rb_node *search,
> +					  rb_cmp_t cmp)
> +{
> +	struct rb_node *n = root->rb_node;
> +	struct rb_node *ret = NULL;
> +
> +	while (n) {
> +		int res = cmp(search, n);
> +
> +		if (res < 0) {
> +			ret = n;
> +			n = n->rb_left;
> +		} else {
> +			n = n->rb_right;
> +		}
> +	}
> +
> +	return ret;
> +}

What does _rb_greater() do?  If these are gonna be inlined, can't we
mostly just have single lookup function which returns either the found
node or insertion position and let each wrapper deal with the
specifics?

Thanks.

-- 
tejun

From: Coly Li <i@coly.li>
Subject: Re: [PATCH 1/1] bcache: use llist_for_each_entry_safe() in
 __closure_wake_up()
Date: Thu, 28 Sep 2017 03:16:43 +0800
Message-ID: <4c14e77e-577f-b7b7-d63a-b4b3a4d9e757@coly.li>
References: <20170926095412.74028-1-colyli@suse.de>
 <20170926095412.74028-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:32926 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbdI0TQ4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2017 15:16:56 -0400
In-Reply-To: <20170926095412.74028-2-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Hi Jens,

Could you please take a look on this patch? It will be helpful if we can
have it in 4.14, then we can fix a bug introduced in 4.14-rc1.

This patch is reported by Michael Lyle, reviewed by Byungchul Park, and
finally verified by Michael Lyle after I posted the patch.

Many thanks in advance.

Coly Li

On 2017/9/26 下午5:54, Coly Li wrote:
> Commit 09b3efec ("bcache: Don't reinvent the wheel but use existing llist
> API") replaces the following while loop by llist_for_each_entry(),
> 
> -
> -	while (reverse) {
> -		cl = container_of(reverse, struct closure, list);
> -		reverse = llist_next(reverse);
> -
> +	llist_for_each_entry(cl, reverse, list) {
>  		closure_set_waiting(cl, 0);
>  		closure_sub(cl, CLOSURE_WAITING + 1);
>  	}
> 
> This modification introduces a potential race by iterating a corrupted
> list. Here is how it happens.
> 
> In the above modification, closure_sub() may wake up a process which is
> waiting on reverse list. If this process decides to wait again by calling
> closure_wait(), its cl->list will be added to another wait list. Then
> when llist_for_each_entry() continues to iterate next node, it will travel
> on another new wait list which is added in closure_wait(), not the
> original reverse list in __closure_wake_up(). It is more probably to
> happen on UP machine because the waked up process may preempt the process
> which wakes up it.
> 
> Use llist_for_each_entry_safe() will fix the issue, the safe version fetch
> next node before waking up a process. Then the copy of next node will make
> sure list iteration stays on original reverse list.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Reported-by: Michael Lyle <mlyle@lyle.org>
> Reviewed-by: Byungchul Park <byungchul.park@lge.com>
> ---
>  drivers/md/bcache/closure.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
> index 7d5286b05036..1841d0359bac 100644
> --- a/drivers/md/bcache/closure.c
> +++ b/drivers/md/bcache/closure.c
> @@ -64,7 +64,7 @@ EXPORT_SYMBOL(closure_put);
>  void __closure_wake_up(struct closure_waitlist *wait_list)
>  {
>  	struct llist_node *list;
> -	struct closure *cl;
> +	struct closure *cl, *t;
>  	struct llist_node *reverse = NULL;
>  
>  	list = llist_del_all(&wait_list->list);
> @@ -73,7 +73,7 @@ void __closure_wake_up(struct closure_waitlist *wait_list)
>  	reverse = llist_reverse_order(list);
>  
>  	/* Then do the wakeups */
> -	llist_for_each_entry(cl, reverse, list) {
> +	llist_for_each_entry_safe(cl, t, reverse, list) {
>  		closure_set_waiting(cl, 0);
>  		closure_sub(cl, CLOSURE_WAITING + 1);
>  	}
> 


-- 
Coly Li

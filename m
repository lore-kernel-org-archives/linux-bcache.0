From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 12/12] closures: fix a race on wakeup from closure_sync
Date: Mon, 22 Jul 2019 13:22:09 -0400
Message-ID: <20190722172209.GA25176@kmo-pixel>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <20190610191420.27007-13-kent.overstreet@gmail.com>
 <8381178e-4c1e-e0fe-430b-a459be1a9389@suse.de>
 <48527b97-e39a-0791-e038-d9f2ec28943e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48527b97-e39a-0791-e038-d9f2ec28943e@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Jul 18, 2019 at 03:46:46PM +0800, Coly Li wrote:
> On 2019/7/16 6:47 下午, Coly Li wrote:
> > Hi Kent,
> > 
> > On 2019/6/11 3:14 上午, Kent Overstreet wrote:
> >> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> > Acked-by: Coly Li <colyli@suse.de>
> > 
> > And also I receive report for suspicious closure race condition in
> > bcache, and people ask for having this patch into Linux v5.3.
> > 
> > So before this patch gets merged into upstream, I plan to rebase it to
> > drivers/md/bcache/closure.c at this moment. Of cause the author is you.
> > 
> > When lib/closure.c merged into upstream, I will rebase all closure usage
> > from bcache to use lib/closure.{c,h}.
> 
> Hi Kent,
> 
> The race bug reporter replies me that the closure race bug is very rare
> to reproduce, after applying the patch and testing, they are not sure
> whether their closure race problem is fixed or not.
> 
> And I notice rcu_read_lock()/rcu_read_unlock() is used here, but it is
> not clear to me what is the functionality of the rcu read lock in
> closure_sync_fn(). I believe you have reason to use the rcu stuffs here,
> could you please provide some hints to help me to understand the change
> better ?

The race was when a thread using closure_sync() notices cl->s->done == 1 before
the thread calling closure_put() calls wake_up_process(). Then, it's possible
for that thread to return and exit just before wake_up_process() is called - so
we're trying to wake up a process that no longer exists.

rcu_read_lock() is sufficient to protect against this, as there's an rcu barrier
somewhere in the process teardown path.

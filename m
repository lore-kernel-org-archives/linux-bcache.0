From: tang.junhui@zte.com.cn
Subject: Re: [PATCH v4 05/13] bcache: stop dc->writeback_rate_update properly
Date: Mon, 29 Jan 2018 20:22:37 +0800
Message-ID: <1517228557-26030-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Coly:

There are some differences,
Using variable of atomic_t type can not guarantee the atomicity of transaction.
for example:
A thread runs in update_writeback_rate()
update_writeback_rate(){
	....
+	if (test_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags)) {
+		schedule_delayed_work(&dc->writeback_rate_update,
 			      dc->writeback_rate_update_seconds * HZ);
+	}

Then another thread executes in cached_dev_detach_finish():
	if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
		cancel_writeback_rate_update_dwork(dc);

+
+	/*
+	 * should check BCACHE_DEV_RATE_DW_RUNNING before calling
+	 * cancel_delayed_work_sync().
+	 */
+	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
+	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
+	smp_mb();

Race still exists.
 
> 
> On 29/01/2018 3:35 PM, tang.junhui@zte.com.cn wrote:
> > From: Tang Junhui <tang.junhui@zte.com.cn>
> > 
> > Hello Coly:
> > 
> > This patch is somewhat difficult for me,
> > I think we can resolve it in a simple way.
> > 
> > We can take the schedule_delayed_work() under the protection of 
> > dc->writeback_lock, and judge if we need re-arm this work to queue.
> > 
> > static void update_writeback_rate(struct work_struct *work)
> > {
> >     struct cached_dev *dc = container_of(to_delayed_work(work),
> >                          struct cached_dev,
> >                          writeback_rate_update);
> > 
> >     down_read(&dc->writeback_lock);
> > 
> >     if (atomic_read(&dc->has_dirty) &&
> >         dc->writeback_percent)
> >         __update_writeback_rate(dc);
> > 
> > -    up_read(&dc->writeback_lock);
> > +    if (NEED_RE-AEMING)    
> >         schedule_delayed_work(&dc->writeback_rate_update,
> >                   dc->writeback_rate_update_seconds * HZ);
> > +    up_read(&dc->writeback_lock);
> > }
> > 
> > In cached_dev_detach_finish() and cached_dev_free() we can set the no need
> > flag under the protection of dc->writeback_lock, for example:
> > 
> > static void cached_dev_detach_finish(struct work_struct *w)
> > {
> >     ...
> > +    down_write(&dc->writeback_lock);
> > +    SET NO NEED RE-ARM FLAG
> > +    up_write(&dc->writeback_lock);
> >     cancel_delayed_work_sync(&dc->writeback_rate_update);
> > }
> > 
> > I think this way is more simple and readable.
> > 
> 
> Hi Junhui,
> 
> Your suggest is essentially almost same to my patch,
> - clear BCACHE_DEV_DETACHING bit acts as SET NO NEED RE-ARM FLAG.
> - cancel_writeback_rate_update_dwork acts as some kind of locking with a
> timeout.
> 
> The difference is I don't use dc->writeback_lock, and replace it by
> BCACHE_DEV_RATE_DW_RUNNING.
> 
> The reason is my following development. I plan to implement a real-time
> update stripe_sectors_dirty of bcache device and cache set, then
> bcache_flash_devs_sectors_dirty() can be very fast and bch_register_lock
> can be removed here. And then I also plan to remove reference of
> dc->writeback_lock in update_writeback_rate() because indeed it is
> unnecessary here (the patch is held by Mike's locking resort work).
> 
> Since I plan to remove dc->writeback_lock from update_writeback_rate(),
> I don't want to reference dc->writeback in the delayed work.
> 
> The basic idea behind your suggestion and this patch, is almost
> identical. The only difference might be the timeout in
> cancel_writeback_rate_update_dwork().
> 
> Thanks.
> 
> Coly Li

Thanks.
Tang Junhui

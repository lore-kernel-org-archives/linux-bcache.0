From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache_writeback: bch_writeback_thread...blk_queue_bio IO hang
 [was BUG: soft lockup]
Date: Mon, 1 Feb 2016 11:42:39 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1602011108460.21204@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:48996 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753165AbcBATmu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 1 Feb 2016 14:42:50 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Yannis Aribaud <bugs@d6bell.net>, linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, vojtech@suse.com

[ changed subject, more below ]

On Fri, 29 Jan 2016, Johannes Thumshirn wrote:

> [ +cc Kent ]
> 
> On Wed, Jan 27, 2016 at 02:57:25PM +0000, Yannis Aribaud wrote:
> > Hi,
> > 
> > After several weeks using the 4.2.6 kernel + patches from Ewheeler we just ran into a crash again.
> > This time the kernel was still running and the server was responsive but not able to do any IO on the bcache devices.
> > 
> > [696983.683498] bcache_writebac D ffffffff810643df     0  5741      2 0x00000000
> > [696983.683505]  ffff88103d01f180 0000000000000046 ffff88107842d000 ffffffff811a95cd
> > [696983.683510]  0000000000000000 ffff8810388c4000 ffff88103d01f180 0000000000000001
> > [696983.683514]  ffff882034ae0c10 0000000000000000 ffff882034ae0000 ffffffff8139601e
> > [696983.683518] Call Trace:
> > [696983.683530]  [<ffffffff811a95cd>] ? blk_queue_bio+0x262/0x279
> > [696983.683539]  [<ffffffff8139601e>] ? schedule+0x6b/0x78
> > [696983.683553]  [<ffffffffa032ce9b>] ? closure_sync+0x66/0x91 [bcache]
> > [696983.683563]  [<ffffffffa033c89f>] ? bch_writeback_thread+0x622/0x6b5 [bcache]
> > [696983.683569]  [<ffffffff8100265c>] ? __switch_to+0x1de/0x3f7
> > [696983.683578]  [<ffffffffa033c89f>] ? bch_writeback_thread+0x622/0x6b5 [bcache]
> > [696983.683586]  [<ffffffffa033c27d>] ? write_dirty_finish+0x1bf/0x1bf [bcache]
> > [696983.683594]  [<ffffffff810589d6>] ? kthread+0x99/0xa1
> > [696983.683598]  [<ffffffff8105893d>] ? kthread_parkme+0x16/0x16
> > [696983.683603]  [<ffffffff813986df>] ? ret_from_fork+0x3f/0x70
> > [696983.683607]  [<ffffffff8105893d>] ? kthread_parkme+0x16/0x16
> > 
> > Don't know if this help.
> > Unfortunately I thing that we will rollback and stop using Bcache unless this is really fixed :/
> > 
> 
> Hi Yannis,
> 
> Do you have a machine with a bcache setup running where you can reproduce the
> error? Or do you know a method to reproduce the error?
> 
> What I'd be interested in is which locks are held when it locks up (you can
> acquire this information with SysRq+d or echo d > /proc/sysrq-trigger.
> 
> Kent, do you have an idea what's happening here?

Are you using md-based raid5/raid6?  

If so, it could be the raid_partial_stripes_expensive bug.

If it *is* the bcache optimizations around partial_stripes_expensive, then
please try the patch below and then do this *before* loading the bcache
module (or at least before registering the bcache backing volume):
        echo 0 > /sys/block/BLK/queue/limits/raid_partial_stripes_expensive
where BLK is your backing volume.

I wrote this patch because we use hardware RAID5/6 and wanted to get the
partial_stripes_expensive optimizations on by setting
raid_partial_stripes_expensive=1 and io_opt=our_stride_width.
Unfortunately it caused the backtrace in the LKML thread below, so we
stopped using it.

See also this thread, however, it shows a backtrace prior to
removing the bio splitting code:
  https://lkml.org/lkml/2016/1/7/844

Note that commit 749b61dab30736eb95b1ee23738cae90973d4fc3 might not 
exactly address this issue, but it might prevent full hangs.  Make sure 
you cherry-pick commit 749b61dab30736eb95b1ee23738cae90973d4fc3 and 
hand-clean-up as necessary. It simplifies the bio code and deletes a bunch 
of stuff.  It showed up in 4.4 and isn't in my patchset.

After commit the commit above and setting 
  raid_partial_stripes_expensive=1 
we still get errors like this:
  bcache: bch_count_io_errors() dm-3: IO error on writing data to cache, 
recovering but they don't lock up the system.  Ultimately we run with 
raid_partial_stripes_expensive=0 because of these related problemsand 
haven't had any issues.  Also, fwiw, we run 4.1.y as our stable branch 
backed by hardware raid.

See my queue_limits patch below which exposes 
  <struct request_queue>::limits
via sysfs.

If anyone does have a fix for this, I would love to see it---because then 
we could use the bcache raid_partial_stripes_expensive/opt_io 
optimizations!

-Eric


diff --git a/block/blk-core.c b/block/blk-core.c
index 03b5f8d..54006aa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -642,6 +642,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	INIT_DELAYED_WORK(&q->delay_work, blk_delay_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
+	kobject_init(&q->ql_kobj, &blk_queue_limits_ktype);
 
 	mutex_init(&q->sysfs_lock);
 	spin_lock_init(&q->__queue_lock);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 2b8fd30..9c29b44 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -430,6 +430,119 @@ static struct attribute *default_attrs[] = {
 	NULL,
 };
 
+/* First we define a show/store function generator 
+ * for `struct queue_limits` */
+#define QL_STORE_FUNC_NAME(name) queue_limits_store_##name
+#define QL_STORE_FUNC(name, type)                                      \
+	static ssize_t                                                 \
+	QL_STORE_FUNC_NAME(name) (struct request_queue *q, const char *page, size_t count)\
+	{                                                              \
+		unsigned long val;                                     \
+		ssize_t ret = queue_var_store(&val, page, count);      \
+		if (ret < 0)                                           \
+			return ret;                                        \
+		q->limits.name = (type) val;                           \
+		return ret;                                            \
+	}
+
+#define QL_SHOW_FUNC_NAME(name) queue_limits_show_##name
+#define QL_SHOW_FUNC(name, type)                                       \
+	static ssize_t                                                 \
+	QL_SHOW_FUNC_NAME(name) (struct request_queue *q, char *page)  \
+	{                                                              \
+		return queue_var_show((unsigned long)q->limits.name, (page));   \
+	}
+
+
+/* Next, the struct generator that defines the 
+ * structs for the queue_limits sysfs interface */
+#define QL_SYSFS_STRUCT_NAME(name) queue_limits_struct_##name
+#define QL_SYSFS_STRUCT(__name, __mode, __show, __store)               \
+	static struct queue_sysfs_entry QL_SYSFS_STRUCT_NAME(__name) = {\
+		.attr = {.name = #__name, .mode = __mode },            \
+		.show = __show,                                        \
+		.store = __store,                                      \
+	};
+
+/* Define common read-only/read-write with functions and mode flags: */
+#define QL_SYSFS_RO(name, type)                                        \
+	QL_SHOW_FUNC(name, type);                                      \
+	QL_SYSFS_STRUCT(name, S_IRUGO, QL_SHOW_FUNC_NAME(name), NULL)
+
+#define QL_SYSFS_RW(name, type)                                        \
+	QL_SHOW_FUNC(name, type);                                      \
+	QL_STORE_FUNC(name, type);                                     \
+	QL_SYSFS_STRUCT(name, S_IRUGO | S_IWUSR,                       \
+		QL_SHOW_FUNC_NAME(name), QL_STORE_FUNC_NAME(name));
+
+
+QL_SYSFS_RO(bounce_pfn, unsigned long);
+QL_SYSFS_RO(seg_boundary_mask, unsigned long);
+
+QL_SYSFS_RO(max_hw_sectors, unsigned int);
+QL_SYSFS_RO(chunk_sectors, unsigned int);
+QL_SYSFS_RO(max_sectors, unsigned int);
+QL_SYSFS_RO(max_segment_size, unsigned int);
+QL_SYSFS_RO(physical_block_size, unsigned int);
+QL_SYSFS_RO(alignment_offset, unsigned int);
+QL_SYSFS_RO(io_min, unsigned int);
+QL_SYSFS_RW(io_opt, unsigned int);
+QL_SYSFS_RO(max_discard_sectors, unsigned int);
+QL_SYSFS_RO(max_write_same_sectors, unsigned int);
+QL_SYSFS_RO(discard_granularity, unsigned int);
+QL_SYSFS_RO(discard_alignment, unsigned int);
+
+QL_SYSFS_RO(logical_block_size, unsigned short);
+QL_SYSFS_RO(max_segments, unsigned short);
+QL_SYSFS_RO(max_integrity_segments, unsigned short);
+
+QL_SYSFS_RO(misaligned, unsigned char);
+QL_SYSFS_RO(discard_misaligned, unsigned char);
+QL_SYSFS_RO(cluster, unsigned char);
+QL_SYSFS_RO(discard_zeroes_data, unsigned char);
+QL_SYSFS_RW(raid_partial_stripes_expensive, unsigned char);
+
+
+/* sysfs attribute list for queue_limits */
+static struct attribute *queue_limits_attrs[] = {
+	&QL_SYSFS_STRUCT_NAME(bounce_pfn).attr,
+	&QL_SYSFS_STRUCT_NAME(seg_boundary_mask).attr,
+
+	&QL_SYSFS_STRUCT_NAME(max_hw_sectors).attr,
+	&QL_SYSFS_STRUCT_NAME(chunk_sectors).attr,
+	&QL_SYSFS_STRUCT_NAME(max_sectors).attr,
+	&QL_SYSFS_STRUCT_NAME(max_segment_size).attr,
+	&QL_SYSFS_STRUCT_NAME(physical_block_size).attr,
+	&QL_SYSFS_STRUCT_NAME(alignment_offset).attr,
+	&QL_SYSFS_STRUCT_NAME(io_min).attr,
+	&QL_SYSFS_STRUCT_NAME(io_opt).attr,
+	&QL_SYSFS_STRUCT_NAME(max_discard_sectors).attr,
+	&QL_SYSFS_STRUCT_NAME(max_write_same_sectors).attr,
+	&QL_SYSFS_STRUCT_NAME(discard_granularity).attr,
+	&QL_SYSFS_STRUCT_NAME(discard_alignment).attr,
+
+	&QL_SYSFS_STRUCT_NAME(logical_block_size).attr,
+	&QL_SYSFS_STRUCT_NAME(max_segments).attr,
+	&QL_SYSFS_STRUCT_NAME(max_integrity_segments).attr,
+	
+	&QL_SYSFS_STRUCT_NAME(misaligned).attr,
+	&QL_SYSFS_STRUCT_NAME(discard_misaligned).attr,
+	&QL_SYSFS_STRUCT_NAME(cluster).attr,
+	&QL_SYSFS_STRUCT_NAME(discard_zeroes_data).attr,
+	&QL_SYSFS_STRUCT_NAME(raid_partial_stripes_expensive).attr,
+
+	NULL
+};
+/* cleanup */
+#undef QL_SYSFS_RW
+#undef QL_SYSFS_RO
+#undef QL_SYSFS_STRUCT
+#undef QL_SYSFS_STRUCT_NAME
+#undef QL_SHOW_FUNC
+#undef QL_SHOW_FUNC_NAME
+#undef QL_STORE_FUNC
+#undef QL_STORE_FUNC_NAME
+
 #define to_queue(atr) container_of((atr), struct queue_sysfs_entry, attr)
 
 static ssize_t
@@ -474,6 +587,48 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 	return res;
 }
 
+static ssize_t
+queue_limits_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
+{
+	struct queue_sysfs_entry *entry = to_queue(attr);
+	struct request_queue *q =
+		container_of(kobj, struct request_queue, ql_kobj);
+	ssize_t res;
+
+	if (!entry->show)
+		return -EIO;
+	mutex_lock(&q->sysfs_lock);
+	if (blk_queue_dying(q)) {
+		mutex_unlock(&q->sysfs_lock);
+		return -ENOENT;
+	}
+	res = entry->show(q, page);
+	mutex_unlock(&q->sysfs_lock);
+	return res;
+}
+
+static ssize_t
+queue_limits_attr_store(struct kobject *kobj, struct attribute *attr,
+		    const char *page, size_t length)
+{
+	struct queue_sysfs_entry *entry = to_queue(attr);
+	struct request_queue *q;
+	ssize_t res;
+
+	if (!entry->store)
+		return -EIO;
+
+	q = container_of(kobj, struct request_queue, ql_kobj);
+	mutex_lock(&q->sysfs_lock);
+	if (blk_queue_dying(q)) {
+		mutex_unlock(&q->sysfs_lock);
+		return -ENOENT;
+	}
+	res = entry->store(q, page, length);
+	mutex_unlock(&q->sysfs_lock);
+	return res;
+}
+
 static void blk_free_queue_rcu(struct rcu_head *rcu_head)
 {
 	struct request_queue *q = container_of(rcu_head, struct request_queue,
@@ -531,6 +686,17 @@ static const struct sysfs_ops queue_sysfs_ops = {
 	.store	= queue_attr_store,
 };
 
+static const struct sysfs_ops queue_limits_sysfs_ops = {
+	.show	= queue_limits_attr_show,
+	.store	= queue_limits_attr_store,
+};
+
+struct kobj_type blk_queue_limits_ktype = {
+	.sysfs_ops	= &queue_limits_sysfs_ops, 
+	.default_attrs	= queue_limits_attrs,
+	.release	= blk_release_queue,
+};
+
 struct kobj_type blk_queue_ktype = {
 	.sysfs_ops	= &queue_sysfs_ops,
 	.default_attrs	= default_attrs,
@@ -573,6 +739,12 @@ int blk_register_queue(struct gendisk *disk)
 	}
 
 	kobject_uevent(&q->kobj, KOBJ_ADD);
+	
+	ret = kobject_add(&q->ql_kobj, kobject_get(&q->kobj), "%s", "limits");
+	if (ret < 0) 
+		return ret;
+	
+	kobject_uevent(&q->ql_kobj, KOBJ_ADD);
 
 	if (q->mq_ops)
 		blk_mq_register_disk(disk);
@@ -605,6 +777,10 @@ void blk_unregister_queue(struct gendisk *disk)
 	if (q->request_fn)
 		elv_unregister_queue(q);
 
+	kobject_uevent(&q->ql_kobj, KOBJ_REMOVE);
+	kobject_del(&q->ql_kobj);
+	kobject_put(&q->kobj);
+
 	kobject_uevent(&q->kobj, KOBJ_REMOVE);
 	kobject_del(&q->kobj);
 	blk_trace_remove_sysfs(disk_to_dev(disk));
diff --git a/block/blk.h b/block/blk.h
index 43b0361..1342e9a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -28,6 +28,7 @@ struct blk_flush_queue {
 extern struct kmem_cache *blk_requestq_cachep;
 extern struct kmem_cache *request_cachep;
 extern struct kobj_type blk_queue_ktype;
+extern struct kobj_type blk_queue_limits_ktype;
 extern struct ida blk_queue_ida;
 
 static inline struct blk_flush_queue *blk_get_flush_queue(
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5d93a66..b58fbf3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -401,6 +401,12 @@ struct request_queue {
 	 * mq queue kobject
 	 */
 	struct kobject mq_kobj;
+	
+	/*
+	 * queue_limits kobject
+	 */
+	struct kobject ql_kobj;
+
 
 #ifdef CONFIG_PM
 	struct device		*dev;

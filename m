From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [RFC] bcache: add stripe_size to superblock and set
 partial_stripes_expensive
Date: Fri, 10 Feb 2017 16:34:22 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1702101623490.5783@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:52864 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751123AbdBKAgb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Feb 2017 19:36:31 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org

Hello Kent,

I've been wanting to set dc->disk.stripe_size and 
dc->partial_stripes_expensive for my hardware RAID5 controller since it 
defines neither q->limits.io_opt nor q->limits.raid_partial_stripes_expensive 
(I think only md sets these at the moment).

I started a patch for the userspace tools to use one of the pad[8]'s as 
the stripe_size before starting a kernel patch and thought I would get 
some feedback before proceeding.  

I figured the superblock is the best place for this since it allocates 
memory in bcache_device_init() for this purpose and needs to know as early 
as possible.  If the SB defines stripe_size, then 
partial_stripes_expensive would be implicit.

However, I think sysfs would be best, but stripe_size is read-only 
(presumably) because stripe_sectors_dirty and full_dirty_stripes would 
need re-allocated.  

What do you think the best way for this might be?

--
Eric Wheeler


diff --git a/bcache-super-show.c b/bcache-super-show.c
index 26cc40e..a35a1c1 100644
--- a/bcache-super-show.c
+++ b/bcache-super-show.c
@@ -161,9 +161,11 @@ int main(int argc, char **argv)
 	printf("dev.uuid\t\t%s\n", uuid);
 
 	printf("dev.sectors_per_block\t%u\n"
-	       "dev.sectors_per_bucket\t%u\n",
+	       "dev.sectors_per_bucket\t%u\n"
+	       "dev.stripe_size\t\t%" PRIu64 "\n",
 	       sb.block_size,
-	       sb.bucket_size);
+	       sb.bucket_size,
+		   sb.stripe_size);
 
 	if (!SB_IS_BDEV(&sb)) {
 		// total_sectors includes the superblock;
diff --git a/bcache.h b/bcache.h
index 61e4252..5213761 100644
--- a/bcache.h
+++ b/bcache.h
@@ -56,7 +56,8 @@ struct cache_sb {
 
 	uint64_t		flags;
 	uint64_t		seq;
-	uint64_t		pad[8];
+	uint64_t		stripe_size;
+	uint64_t		pad[7];
 
 	union {
 	struct {
diff --git a/make-bcache.c b/make-bcache.c
index c626eae..442a8a3 100644
--- a/make-bcache.c
+++ b/make-bcache.c
@@ -151,6 +151,7 @@ void usage()
 	       "	-b, --bucket		bucket size\n"
 	       "	-w, --block		block size (hard sector size of SSD, often 2k)\n"
 	       "	-o, --data-offset	data offset in sectors\n"
+	       "	-z, --stripe-size	bdev stripe size in bytes\n"
 	       "	    --cset-uuid		UUID for the cache set\n"
 //	       "	-U			UUID\n"
 	       "	    --writeback		enable writeback\n"
@@ -171,6 +172,7 @@ static void write_sb(char *dev, unsigned block_size, unsigned bucket_size,
 		     bool writeback, bool discard, bool wipe_bcache,
 		     unsigned cache_replacement_policy,
 		     uint64_t data_offset,
+		     uint64_t stripe_size,
 		     uuid_t set_uuid, bool bdev)
 {
 	int fd;
@@ -232,15 +234,19 @@ static void write_sb(char *dev, unsigned block_size, unsigned bucket_size,
 			sb.data_offset = data_offset;
 		}
 
+		sb.stripe_size = stripe_size;
+
 		printf("UUID:			%s\n"
 		       "Set UUID:		%s\n"
 		       "version:		%u\n"
 		       "block_size:		%u\n"
 		       "data_offset:		%ju\n",
+		       "stripe_size:		%ju\n",
 		       uuid_str, set_uuid_str,
 		       (unsigned) sb.version,
 		       sb.block_size,
-		       data_offset);
+		       data_offset,
+		       stripe_size);
 	} else {
 		sb.nbuckets		= getblocks(fd) / sb.bucket_size;
 		sb.nr_in_set		= 1;
@@ -346,6 +352,7 @@ int main(int argc, char **argv)
 	int writeback = 0, discard = 0, wipe_bcache = 0;
 	unsigned cache_replacement_policy = 0;
 	uint64_t data_offset = BDEV_DATA_START_DEFAULT;
+	uint64_t stripe_size = 0;
 	uuid_t set_uuid;
 
 	uuid_generate(set_uuid);
@@ -362,6 +369,8 @@ int main(int argc, char **argv)
 		{ "cache-replacement-policy", 1, NULL, 'p' },
 		{ "data_offset",	1, NULL,	'o' },
 		{ "data-offset",	1, NULL,	'o' },
+		{ "stripe_size",	1, NULL,	'z' },
+		{ "stripe-size",	1, NULL,	'z' },
 		{ "cset-uuid",		1, NULL,	'u' },
 		{ "help",		0, NULL,	'h' },
 		{ NULL,			0, NULL,	0 },
@@ -402,6 +411,8 @@ int main(int argc, char **argv)
 				       BDEV_DATA_START_DEFAULT);
 				exit(EXIT_FAILURE);
 			}
+		case 'z':
+			stripe_size = atoll(optarg);
 			break;
 		case 'u':
 			if (uuid_parse(optarg, set_uuid)) {
@@ -449,13 +460,13 @@ int main(int argc, char **argv)
 		write_sb(cache_devices[i], block_size, bucket_size,
 			 writeback, discard, wipe_bcache,
 			 cache_replacement_policy,
-			 data_offset, set_uuid, false);
+			 data_offset, stripe_size, set_uuid, false);
 
 	for (i = 0; i < nbacking_devices; i++)
 		write_sb(backing_devices[i], block_size, bucket_size,
 			 writeback, discard, wipe_bcache,
 			 cache_replacement_policy,
-			 data_offset, set_uuid, true);
+			 data_offset, stripe_size, set_uuid, true);
 
 	return 0;
 }

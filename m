From: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Subject: Re: super-block written got dislocation while 64K PAGE_SIZE enable.
Date: Thu, 2 Jun 2016 11:54:35 +0800
Message-ID: <CAOOPZo6bp4F03QVrB0fvXieW_7moqhWcuoa068q9afwfzrJsCQ@mail.gmail.com>
References: <CAOOPZo6+dtw9VWHnMhR8LEeFxEdNGOMthCw-PqRNmnLP2eAq1g@mail.gmail.com>
	<alpine.LRH.2.11.1606011057370.9562@mail.ewheeler.net>
	<20160601231633.GA32542@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:33926 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbcFBDyg (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 1 Jun 2016 23:54:36 -0400
Received: by mail-yw0-f194.google.com with SMTP id j74so5335117ywg.1
        for <linux-bcache@vger.kernel.org>; Wed, 01 Jun 2016 20:54:36 -0700 (PDT)
In-Reply-To: <20160601231633.GA32542@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

To support arbitrary page size for superblock,include 4K/8K/64K
currently, the off_set of SB_SECTOR should be a LCM(least common
multiple) and that is 64. I redefine macro SB_SECTOR and
BDEV_DATA_START_DEFAULT just as bellow patch showed:
        diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
        index ef567cd..1622f44 100644
        --- a/drivers/md/bcache/super.c
        +++ b/drivers/md/bcache/super.c
        @@ -74,7 +74,7 @@ static const char *read_super(struct
cache_sb *sb, struct block_device *bdev,
         {
                const char *err;
                struct cache_sb *s;
        -       struct buffer_head *bh = __bread(bdev, 1, SB_SIZE);
        +       struct buffer_head *bh = __bread(bdev, 16, SB_SIZE);
                unsigned i;

                if (!bh)
        diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
        index 22b6ad3..eb948c8 100644
        --- a/include/uapi/linux/bcache.h
        +++ b/include/uapi/linux/bcache.h
        @@ -144,14 +144,14 @@ static inline struct bkey
*bkey_idx(const struct bkey *k, unsigned nr_keys)
         #define BCACHE_SB_VERSION_BDEV_WITH_OFFSET 4
         #define BCACHE_SB_MAX_VERSION          4

        -#define SB_SECTOR                      8
        +#define SB_SECTOR                      128
         #define SB_SIZE                                4096
         #define SB_LABEL_SIZE                  32
         #define SB_JOURNAL_BUCKETS             256U
         /* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
         #define MAX_CACHES_PER_SET             8

        -#define BDEV_DATA_START_DEFAULT                16      /* sectors */
        +#define BDEV_DATA_START_DEFAULT                    256 /* sectors */

         struct cache_sb {
                __u64                   csum;

The second arg of __bread(bdev, 16, SB_SIZE)  has unit of block size
and it need be relocated too.
To suitable this change, bcache-tools need be fixed up too.
As for btree_node_size issues about page size, expecting somebody to
commit a patch.

Kent, maybe you could use qemu to simulate ARM64 arch and there is
always ubuntu image for ARM64 on the internet.

2016-06-02 7:16 GMT+08:00 Kent Overstreet <kent.overstreet@gmail.com>:
> On Wed, Jun 01, 2016 at 11:05:20AM -0700, Eric Wheeler wrote:
>> On Wed, 1 Jun 2016, Zhengyuan Liu wrote:
>>
>> > Hi, I have created a mapped block device (bcach0) using make-bcache on
>> > ARM64 server which has kernel enable 64K page size. However, the
>> > bcach0 disappeared after the server reboot and there is no or dirty
>> > metadata on super block of both cache device and back device . The
>> > output of command  bcache-super-show was as bellow showed:
>> >    [root@master Linux-4.4-LTS-storage]# bcache-super-show  /dev/sdb
>> >    sb.magic bad magic
>> >    Invalid superblock (bad magic)
>> > /dev/sdb was the backing device and cache device got bad magic too.
>> >
>> > I tried to traced the written process of super block in bcache source
>> > code and found that is the issue of PAGE_SIZE. It seems that the
>> > bcache  was designed only considering for 4K PAGE_SIZE and it works
>> > right only on 4K PAGE_SIZE exactly. To make bcache work correctly on
>> > 64K PAGE_SIZE, I committed a patch as bellow showd:
>> >     diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> >     index 330cd6e..ef567cd 100644
>> >     --- a/drivers/md/bcache/super.c
>> >     +++ b/drivers/md/bcache/super.c
>> >     @@ -224,6 +224,12 @@ static void __write_super(struct cache_sb
>> > *sb, struct bio     *bio
>> >         bio->bi_iter.bi_size    = SB_SIZE;
>> >         bch_bio_map(bio, NULL);
>> >
>> >     +#ifdef CONFIG_ARM64_64K_PAGES
>> >     +       out = (struct cache_sb *)((char *)out + (SB_SECTOR<<9));
>> >     +       pr_debug("sb_page_adress %x, sb_address %x,page_size
>> >           %d\n",page_address(bio
>> >     +       bio->bi_io_vec[0].bv_offset = (SB_SECTOR<<9);
>> >     +#endif
>> >
>> >         out->offset             = cpu_to_le64(sb->offset);
>> >         out->version            = cpu_to_le64(sb->version);
>> >
>> > Does it not recommend to use bcache on 64K PAGE_SIZE? or it only
>> > considers for 4K PAGE_SIZE for bcache currently?
>> > Maybe it is more suitable  for me to redefine some macro such as
>> > SB_SECTOR, BDEV_DATA_START_DEFAULT to make bcache work correctly on
>> > both 64K PAGE_SIZE and 4K PAGE_SIZE.
>>
>> I think a patch to support arbitrary page size would be great.  Can
>> you write the macros in terms of PAGE_SIZE or PAGE_SHIFT?
>
> It shouldn't be referencing PAGE_SIZE at all - creating a new macro
> (BCH_SB_SIZE, perhaps) is the correct approach.
>
> The code that allocates the buffer for the superblock will have to be fixed
> too - right now it's probably using __get_free_page(), it should probably just
> be switched to kmalloc().
>
>> (Out of curiosity, what ARM64 hardware are you using?)
>>
>> Kent, this may affect bcachefs too.  Can you think of any other places
>> that might have PAGE_SIZE!=4k issues?
>
> Oh, there's probably a couple. There's probably some stuff that'll break if
> btree_node_size is smaller than PAGE_SIZE, too...
>
> If it turns out to be too much for Zhengyuan, I can probably fix upstream too
> (but I don't have any hardware to test with).

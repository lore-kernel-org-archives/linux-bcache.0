From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 1/2] bcachefs: On disk data structures
Date: Sun, 13 May 2018 13:30:06 -0700
Message-ID: <dea41935-a52c-e720-0ca3-eef4367d3641@infradead.org>
References: <20180508221800.2642-1-kent.overstreet@gmail.com>
 <20180508221800.2642-2-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508221800.2642-2-kent.overstreet@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, hare@suse.com
List-Id: linux-bcache@vger.kernel.org

Hi.

On 05/08/2018 03:17 PM, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>  fs/bcachefs/bcachefs_format.h | 1448 +++++++++++++++++++++++++++++++++
>  1 file changed, 1448 insertions(+)
>  create mode 100644 fs/bcachefs/bcachefs_format.h
> 
> diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> new file mode 100644
> index 0000000000..0961585c7e
> --- /dev/null
> +++ b/fs/bcachefs/bcachefs_format.h
> @@ -0,0 +1,1448 @@
> +#ifndef _BCACHEFS_FORMAT_H
> +#define _BCACHEFS_FORMAT_H
> +
> +/*
> + * bcachefs on disk data structures
> + *
> + * OVERVIEW:
> + *
> + * There are three main types of on disk data structures in bcachefs (this is
> + * reduced from 5 in bcache)
> + *
> + *  - superblock
> + *  - journal
> + *  - btree
> + *
> + * The btree is the primary structure, most metadata exists as keys in the

s/,/;/

> + * various btrees. There are only a small number of btrees, they're not
> + * sharded - we have one btree for extents, another for inodes, et cetera.

   or shared?

> + *
> + * SUPERBLOCK:
> + *
> + * The superblock contains the location of the journal, the list of devices in
> + * the filesystem, and in general any metadata we need in order to decide
> + * whether we can start a filesystem or prior to reading the journal/btree
> + * roots.


[snip]

> +struct bkey_format {
> +	__u8		key_u64s;
> +	__u8		nr_fields;
> +	/* One unused slot for now: */
> +	__u8		bits_per_field[6];
> +	__le64		field_offset[6];
> +};
> +
> +/* Btree keys - all units are in sectors */

Are sectors fixed size?  I.e., can 2 different physical storage devices have
different sized sectors?
or is this just the "traditional" 512-byte sector?


[snip]



> +/* Extents */
> +
> +/*
> + * In extent bkeys, the value is a list of pointers (bch_extent_ptr), optionally
> + * preceded by checksum/compression information (bch_extent_crc32 or
> + * bch_extent_crc64).
> + *
> + * One major determining factor in the format of extents is how we handle and
> + * represent extents that have been partially overwritten and thus trimmed:
> + *
> + * If an extent is not checksummed or compressed, when the extent is trimmed we
> + * don't have to remember the extent we originally allocated and wrote: we can
> + * merely adjust ptr->offset to point to the start of the start of the data that

                                         to the start of the start  [intentional?]

> + * is currently live. The size field in struct bkey records the current (live)
> + * size of the extent, and is also used to mean "size of region on disk that we
> + * point to" in this case.


[snip]


> +/*
> + * @offset	- sector where this sb was written
> + * @version	- on disk format version
> + * @magic	- identifies as a bcachefs superblock (BCACHE_MAGIC)
> + * @seq		- incremented each time superblock is written
> + * @uuid	- used for generating various magic numbers and identifying
> + *                member devices, never changes
> + * @user_uuid	- user visible UUID, may be changed
> + * @label	- filesystem label
> + * @seq		- identifies most recent superblock, incremented each time
> + *		  superblock is written
> + * @features	- enabled incompatible features
> + */
> +struct bch_sb {
> +	struct bch_csum		csum;
> +	__le64			version;
> +	uuid_le			magic;
> +	uuid_le			uuid;
> +	uuid_le			user_uuid;
> +	__u8			label[BCH_SB_LABEL_SIZE];
> +	__le64			offset;
> +	__le64			seq;
> +
> +	__le16			block_size;
> +	__u8			dev_idx;
> +	__u8			nr_devices;
> +	__le32			u64s;
> +
> +	__le64			time_base_lo;
> +	__le32			time_base_hi;
> +	__le32			time_precision;
> +
> +	__le64			flags[8];
> +	__le64			features[2];
> +	__le64			compat[2];
> +
> +	struct bch_sb_layout	layout;
> +
> +	union {
> +		struct bch_sb_field start[0];
> +		__le64		_data[0];
> +	};
> +} __attribute__((packed, aligned(8)));


I know that you have already answered a few comments about endianness,
so maybe you answered this and I missed it.

Can a bcachefs fs be shared, a la NFS?  I.e., can multiple different-endian
clients be accessing the same bcachefs?

thanks,
-- 
~Randy

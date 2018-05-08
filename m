From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 2/2] bcachefs: Ioctl interface
Date: Tue,  8 May 2018 18:18:00 -0400
Message-ID: <20180508221800.2642-3-kent.overstreet@gmail.com>
References: <20180508221800.2642-1-kent.overstreet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508221800.2642-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, hare@suse.com
List-Id: linux-bcache@vger.kernel.org

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 fs/bcachefs/bcachefs_ioctl.h | 182 +++++++++++++++++++++++++++++++++++
 1 file changed, 182 insertions(+)
 create mode 100644 fs/bcachefs/bcachefs_ioctl.h

diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
new file mode 100644
index 0000000000..4442a02b5c
--- /dev/null
+++ b/fs/bcachefs/bcachefs_ioctl.h
@@ -0,0 +1,182 @@
+#ifndef _BCACHEFS_IOCTL_H
+#define _BCACHEFS_IOCTL_H
+
+#include <linux/uuid.h>
+#include <asm/ioctl.h>
+#include "bcachefs_format.h"
+
+/*
+ * Flags common to multiple ioctls:
+ */
+#define BCH_FORCE_IF_DATA_LOST		(1 << 0)
+#define BCH_FORCE_IF_METADATA_LOST	(1 << 1)
+#define BCH_FORCE_IF_DATA_DEGRADED	(1 << 2)
+#define BCH_FORCE_IF_METADATA_DEGRADED	(1 << 3)
+
+#define BCH_FORCE_IF_DEGRADED			\
+	(BCH_FORCE_IF_DATA_DEGRADED|		\
+	 BCH_FORCE_IF_METADATA_DEGRADED)
+
+/*
+ * If cleared, ioctl that refer to a device pass it as a pointer to a pathname
+ * (e.g. /dev/sda1); if set, the dev field is the device's index within the
+ * filesystem:
+ */
+#define BCH_BY_INDEX			(1 << 4)
+
+/*
+ * For BCH_IOCTL_READ_SUPER: get superblock of a specific device, not filesystem
+ * wide superblock:
+ */
+#define BCH_READ_DEV			(1 << 5)
+
+/* global control dev: */
+
+/* These are currently broken, and probably unnecessary: */
+#if 0
+#define BCH_IOCTL_ASSEMBLE	_IOW(0xbc, 1, struct bch_ioctl_assemble)
+#define BCH_IOCTL_INCREMENTAL	_IOW(0xbc, 2, struct bch_ioctl_incremental)
+
+struct bch_ioctl_assemble {
+	__u32			flags;
+	__u32			nr_devs;
+	__u64			pad;
+	__u64			devs[];
+};
+
+struct bch_ioctl_incremental {
+	__u32			flags;
+	__u64			pad;
+	__u64			dev;
+};
+#endif
+
+/* filesystem ioctls: */
+
+#define BCH_IOCTL_QUERY_UUID	_IOR(0xbc,	1,  struct bch_ioctl_query_uuid)
+#define BCH_IOCTL_START		_IOW(0xbc,	2,  struct bch_ioctl_start)
+#define BCH_IOCTL_STOP		_IO(0xbc,	3)
+#define BCH_IOCTL_DISK_ADD	_IOW(0xbc,	4,  struct bch_ioctl_disk)
+#define BCH_IOCTL_DISK_REMOVE	_IOW(0xbc,	5,  struct bch_ioctl_disk)
+#define BCH_IOCTL_DISK_ONLINE	_IOW(0xbc,	6,  struct bch_ioctl_disk)
+#define BCH_IOCTL_DISK_OFFLINE	_IOW(0xbc,	7,  struct bch_ioctl_disk)
+#define BCH_IOCTL_DISK_SET_STATE _IOW(0xbc,	8,  struct bch_ioctl_disk_set_state)
+#define BCH_IOCTL_DATA		_IOW(0xbc,	10, struct bch_ioctl_data)
+#define BCH_IOCTL_USAGE		_IOWR(0xbc,	11, struct bch_ioctl_usage)
+#define BCH_IOCTL_READ_SUPER	_IOW(0xbc,	12, struct bch_ioctl_read_super)
+#define BCH_IOCTL_DISK_GET_IDX	_IOW(0xbc,	13,  struct bch_ioctl_disk_get_idx)
+#define BCH_IOCTL_DISK_RESIZE	_IOW(0xbc,	13,  struct bch_ioctl_disk_resize)
+
+struct bch_ioctl_query_uuid {
+	uuid_le			uuid;
+};
+
+struct bch_ioctl_start {
+	__u32			flags;
+	__u32			pad;
+};
+
+struct bch_ioctl_disk {
+	__u32			flags;
+	__u32			pad;
+	__u64			dev;
+};
+
+struct bch_ioctl_disk_set_state {
+	__u32			flags;
+	__u8			new_state;
+	__u8			pad[3];
+	__u64			dev;
+};
+
+/*
+ * BCH_IOCTL_DATA: operations that walk and manipulate filesystem data (e.g.
+ * scrub, rereplicate, migrate).
+ *
+ * This ioctl kicks off a job in the background, and returns a file descriptor.
+ * Reading from the file descriptor returns a struct bch_ioctl_data_progress,
+ * indicating current progress, and closing the file descriptor will stop the
+ * job. The file descriptor is O_CLOEXEC.
+ */
+
+enum bch_data_ops {
+	BCH_DATA_OP_SCRUB	= 0,
+	BCH_DATA_OP_REREPLICATE	= 1,
+	BCH_DATA_OP_MIGRATE	= 2,
+	BCH_DATA_OP_NR		= 3,
+};
+
+struct bch_ioctl_data {
+	__u32			op;
+	__u32			flags;
+
+	struct bpos		start;
+	struct bpos		end;
+
+	union {
+	struct {
+		__u32		dev;
+		__u32		pad;
+	}			migrate;
+	};
+} __attribute__((packed, aligned(8)));
+
+struct bch_ioctl_data_progress {
+	__u8			data_type;
+	__u8			btree_id;
+	__u8			pad[2];
+	struct bpos		pos;
+
+	__u64			sectors_done;
+	__u64			sectors_total;
+} __attribute__((packed, aligned(8)));
+
+struct bch_ioctl_dev_usage {
+	__u8			state;
+	__u8			alive;
+	__u8			pad[6];
+	__u32			dev;
+
+	__u32			bucket_size;
+	__u64			nr_buckets;
+
+	__u64			buckets[BCH_DATA_NR];
+	__u64			sectors[BCH_DATA_NR];
+};
+
+struct bch_ioctl_fs_usage {
+	__u64			capacity;
+	__u64			used;
+	__u64			online_reserved;
+	__u64			persistent_reserved[BCH_REPLICAS_MAX];
+	__u64			sectors[BCH_DATA_NR][BCH_REPLICAS_MAX];
+};
+
+struct bch_ioctl_usage {
+	__u16			nr_devices;
+	__u16			pad[3];
+
+	struct bch_ioctl_fs_usage fs;
+	struct bch_ioctl_dev_usage devs[0];
+};
+
+struct bch_ioctl_read_super {
+	__u32			flags;
+	__u32			pad;
+	__u64			dev;
+	__u64			size;
+	__u64			sb;
+};
+
+struct bch_ioctl_disk_get_idx {
+	__u64			dev;
+};
+
+struct bch_ioctl_disk_resize {
+	__u32			flags;
+	__u32			pad;
+	__u64			dev;
+	__u64			nbuckets;
+};
+
+#endif /* _BCACHEFS_IOCTL_H */
-- 
2.17.0

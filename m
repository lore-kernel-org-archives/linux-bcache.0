From: Ian Pilcher <arequipeno@gmail.com>
Subject: RFC: Handle "device busy" error when registering
Date: Tue, 22 Jul 2014 00:13:00 -0500
Message-ID: <lqkrss$h1s$1@ger.gmane.org>
References: <lqcd46$hvl$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010708080608020500080000"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36438 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaGVFNQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 22 Jul 2014 01:13:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1X9SO1-0000Qi-Ih
	for linux-bcache@vger.kernel.org; Tue, 22 Jul 2014 07:13:13 +0200
Received: from pool-173-57-185-5.dllstx.fios.verizon.net ([173.57.185.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 22 Jul 2014 07:13:13 +0200
Received: from arequipeno by pool-173-57-185-5.dllstx.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 22 Jul 2014 07:13:13 +0200
In-Reply-To: <lqcd46$hvl$1@ger.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------010708080608020500080000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 07/18/2014 07:11 PM, Ian Pilcher wrote:
> Suggested fix:
> 
> (1) Change bcache_register to return -EBUSY in the device busy case
>     (while still returning -EINVAL in the already registered case).
> 
> (2) Change bcache-register to check the exit code of the registration
>     attempt and retry in the EBUSY case.
> 
> Does this make sense?

I've gone ahead and implemented an initial version of this approach.
See the attached files:

* linux-bcache-register-retval.patch - Makes bcache_register return
  -EBUSY when it is unable to get exclusive access to the device, but
  the device is not already registered.  It still returns -EINVAL in all
  other error cases.

  This allows userspace to distinguish the "device busy" case from other
  errors.  I couldn't find an easy way to make this determination from a
  shell script, though, so I created ...

* bcreg.c - This does most of the work that was previously done in the
  bcache-register script.  Specifically, it will wait for the sysfs
  register file to be created and then write the name of the device to
  that file -- retrying if it encounters an EBUSY.

* bcache-register - bcreg doesn't call modprobe, so this script is still
  required.  It now calls bcreg to register the device.

Thoughts?

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================

--------------010708080608020500080000
Content-Type: text/plain; charset=UTF-8;
 name="bcache-register"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bcache-register"

#!/bin/sh
/sbin/modprobe -qba bcache
exec /usr/lib/udev/bcreg $1

--------------010708080608020500080000
Content-Type: text/x-csrc;
 name="bcreg.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bcreg.c"

#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>

/* How often to wake up and check when waiting for something; 1/10 second */
#define WAKEUP_NSEC		100000000L

/* Timeouts are in multiples of WAKEUP_NSEC */
#define SYSFS_TIMEOUT		50	/* 5 seconds */
#define DEVICE_TIMEOUT		50	/* 5 seconds */

static const char sysfs_reg[] = "/sys/fs/bcache/register";

int main(int argc, char *argv[])
{
	struct timespec timeout;
	size_t len;
	int i, fd;

	if (argc != 2) {
		fprintf(stderr, "USAGE: %s <BLOCK_DEVICE>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	i = SYSFS_TIMEOUT;

	while (1) {

		fd = open(sysfs_reg, O_WRONLY);
		if (fd != -1)
			break;

		if (errno != ENOENT) {
			perror(sysfs_reg);
			exit(EXIT_FAILURE);
		}

		if (i-- == 0) {
			fprintf(stderr, "Timed out waiting for %s\n", sysfs_reg);
			exit(EXIT_FAILURE);
		}

		timeout.tv_sec = 0;
		timeout.tv_nsec = WAKEUP_NSEC;

		if (nanosleep(&timeout, NULL) == -1) {
			perror("nanosleep");
			exit(EXIT_FAILURE);
		}
	}

	len = strlen(argv[1]);
	i = DEVICE_TIMEOUT;

	while (1) {

		if (lseek(fd, 0, SEEK_SET) == -1) {
			perror(sysfs_reg);
			close(fd);
			exit(EXIT_FAILURE);
		}

		if (write(fd, argv[1], len) == (ssize_t)len)
			break;

		if (errno != EBUSY) {
			perror(argv[1]);
			close(fd);
			exit(EXIT_FAILURE);
		}

		if (i-- == 0) {
			fprintf(stderr, "Timed out waiting for %s\n", argv[1]);
			close(fd);
			exit(EXIT_FAILURE);
		}

		timeout.tv_sec = 0;
		timeout.tv_nsec = WAKEUP_NSEC;

		if (nanosleep(&timeout, NULL) == -1) {
			perror("nanosleep");
			close(fd);
			exit(EXIT_FAILURE);
		}
	}

	close(fd);
	return 0;
}

--------------010708080608020500080000
Content-Type: text/x-patch;
 name="linux-bcache-register-retval.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linux-bcache-register-retval.patch"

--- ./drivers/md/bcache/super.c.orig	2014-07-21 09:43:03.599875510 -0400
+++ ./drivers/md/bcache/super.c	2014-07-21 11:22:56.774478317 -0400
@@ -1924,7 +1924,7 @@
 static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			       const char *buffer, size_t size)
 {
-	ssize_t ret = size;
+	ssize_t ret = -EINVAL;
 	const char *err = "cannot allocate memory";
 	char *path = NULL;
 	struct cache_sb *sb = NULL;
@@ -1945,10 +1945,12 @@
 	if (IS_ERR(bdev)) {
 		if (bdev == ERR_PTR(-EBUSY)) {
 			bdev = lookup_bdev(strim(path));
-			if (!IS_ERR(bdev) && bch_is_open(bdev))
+			if (!IS_ERR(bdev) && bch_is_open(bdev)) {
 				err = "device already registered";
-			else
+			} else {
 				err = "device busy";
+				ret = -EBUSY;
+			}
 		}
 		goto err;
 	}
@@ -1976,6 +1978,9 @@
 
 		register_cache(sb, sb_page, bdev, ca);
 	}
+
+	ret = size;
+
 out:
 	if (sb_page)
 		put_page(sb_page);
@@ -1989,7 +1994,6 @@
 err:
 	if (attr != &ksysfs_register_quiet)
 		pr_info("error opening %s: %s", path, err);
-	ret = -EINVAL;
 	goto out;
 }
 

--------------010708080608020500080000--

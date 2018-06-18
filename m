From: Florian Schmaus <flo@geekplace.eu>
Subject: [PATCH 0/3] bcache: Fix variable assignment in if condition in super.c
Date: Mon, 18 Jun 2018 12:08:59 +0200
Message-ID: <20180618100902.4015-1-flo@geekplace.eu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org
Cc: Florian Schmaus <flo@geekplace.eu>, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

This patch set attempts to improve bcache's super.c code by moving the
assignment of variables out of 'if' conditions. It does not address
all occurences of this style issue (which is reported as error by
checkpatch.pl).

Florian Schmaus (3):
  bcache: do not assign in if condition register_bcache()
  bcache: do not assign in if condition in bcache_init()
  bcache: do not assign in if condition in bcache_device_init()

 drivers/md/bcache/super.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

-- 
2.16.4

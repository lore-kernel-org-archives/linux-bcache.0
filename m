From: Michael Lyle <mlyle@lyle.org>
Subject: Urgent fix for 4.15: 62530ed8b1d (bio: ensure __bio_clone_fast copies bi_partno)
Date: Mon, 20 Nov 2017 15:47:40 -0800
Message-ID: <CAJ+L6qdy2TQ0K=syErR_OEvAGJF7Cacc_79mnD=SEC=uQTYVpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable <stable@vger.kernel.org>, gregkh@linuxfoundation.org, linux-bcache <linux-bcache@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

Hi---

Previously sent to stable was this patch, and it's made it into
Linus's tree for 4.16.  It's a rather urgent data corruption issue
that affects at minimum bcache but possibly other block subsystems.
Several users have lost data.  The issue was introduced in the 4.15
branch by 74d46992e0d9 ("block: replace bi_bdev with a gendisk pointer
and partitions index").

I'd really appreciate anything that can be done to get this into a
stable 4.15 release soon.

Thanks--

Mike

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent for hardware raid5/6
Date: Mon, 24 Jun 2019 19:24:44 -0400
Message-ID: <yq17e9ao9c3.fsf@oracle.com>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
        <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
        <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
        <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net> (Eric
        Wheeler's message of "Mon, 24 Jun 2019 18:14:59 +0000 (UTC)")
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Kent Overstreet <kent.overstreet@gmail.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-bcache@vger.kernel.org


Eric,

> Perhaps they do not set stripe_width using io_opt? I did a grep to see
> if any of them did, but I didn't see them. How is stripe_width
> indicated by RAID controllers?

The values are reported in the Block Limits VPD page for each SCSI block
device and are thus set by the SCSI disk driver. IOW, the RAID
controller device drivers have nothing to do with this.

For RAID controllers specifically, the controller firmware will fill out
the VPD fields for each virtual SCSI disk when you configure a RAID
set. For pretty much everything else, the Block Limits come straight
from the device itself.

Also note that these values aren't specific to RAID controllers at
all. Most new SCSI devices, including disk drives and SSDs, will fill
out the Block Limits VPD page one way or the other. Even some USB
storage devices are providing this page.

> If they do set io_opt, then at least my Areca 1883 does not set io_opt
> as of 4.19.x. I also have a LSI MegaRAID 3108 which does not report
> io_opt as of 4.1.x, but that is an older kernel so maybe support has
> been added since then.

I have several MegaRAIDs that all report it. But it depends on the
controller firmware.

> Is it visible through sysfs or debugfs so I can check my hardware
> support without hacking debugging the kernel?

To print the block device topology:

  # lsblk -t

or look up io_opt in sysfs:

  # grep . /sys/block/sdX/queue/optimal_io_size

You can also query a SCSI device's Block Limits directly:

  # sg_vpd -p bl /dev/sdX

If you want to tinker, you can simulate a SCSI disk with your choice of
io_opt:

  # modprobe scsi_debug opt_blks=N

where N is the number of logical blocks to report as being the optimal
I/O size.

-- 
Martin K. Petersen	Oracle Linux Engineering

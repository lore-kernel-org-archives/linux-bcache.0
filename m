From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent for hardware raid5/6
Date: Sat, 22 Jun 2019 20:41:11 -0400
Message-ID: <yq1v9wxnnfc.fsf@oracle.com>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
        <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
        (Eric Wheeler's message of "Sat, 22 Jun 2019 16:16:09 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, Eric Wheeler <git@linux.ewheeler.net>, Eric Wheeler <bcache@linux.ewheeler.net>, Jonathan Corbet <corbet@lwn.net>, Kent Overstreet <kent.overstreet@gmail.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org


Eric,

> While some drivers set queue_limits.io_opt (e.g., md raid5), there are
> currently no SCSI/RAID controller drivers that do.

That's not true. Lots of SCSI RAID devices report a stripe width.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent for hardware raid5/6
Date: Tue, 25 Jun 2019 22:50:47 -0400
Message-ID: <yq1ef3hm54o.fsf@oracle.com>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
        <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
        <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
        <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
        <yq17e9ao9c3.fsf@oracle.com>
        <alpine.LRH.2.11.1906260005570.1114@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1906260005570.1114@mx.ewheeler.net> (Eric
        Wheeler's message of "Wed, 26 Jun 2019 00:23:09 +0000 (UTC)")
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Kent Overstreet <kent.overstreet@gmail.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org


Eric,

> * LSI 2108 (Supermicro)
> * LSI 3108 (Dell)
> * Areca 1882
> * Areca 1883
> * Fibrechannel 8gbe connected to a Storwize 3700

I have a 3108 that provides the BL VPD. Surprised the 1883 doesn't.

As a rule of thumb, you need 12 Gbps SAS or 16 Gbps FC devices for the
VPD page to be present. The protocol feature is not tied to the
transport signaling speed in any way. But general support for the BL VPD
page roughly coincided with vendors introducing 12 Gbps SAS and 16 Gbps
FC products to the market.

-- 
Martin K. Petersen	Oracle Linux Engineering

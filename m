From: Wido den Hollander <wido@42on.com>
Subject: Partitions on bcache devices
Date: Wed, 28 Sep 2016 15:45:07 +0200 (CEST)
Message-ID: <951934014.5256.1475070307225@ox.pcextreme.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp01.mail.pcextreme.nl ([109.72.87.137]:51517 "EHLO
        smtp01.mail.pcextreme.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932348AbcI1Nu0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Sep 2016 09:50:26 -0400
Received: from 109.72.87.221 (ox01.pcextreme.nl [109.72.87.221])
        by smtp01.mail.pcextreme.nl (Postfix) with ESMTPSA id 5F535760AF
        for <linux-bcache@vger.kernel.org>; Wed, 28 Sep 2016 15:45:07 +0200 (CEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

Currently it is not possible to create partitions on bcache devices, eg, if you have bcache0 you can't create bcache0p1, bcache0p2, etc.

There are patches [0] out there which 'enable' this, but they aren't suited to be send upstream.

For the Ceph [1] project it would be very beneficial if bcache would support the creation of partitions on the devices.

I'm not a kernel nor bcache developer, so I don't know what has to be done exactly, but I'm trying to see if this can be implemented in this year.

Is work for this underway? If yes, what is the status? If not, what has to be done and how can I assist / support it?

Thanks!

Wido

[0]: https://yaple.net/2016/03/31/bcache-partitions-and-dkms/
[1]: http://ceph.com/

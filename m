From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: bcache shutdown sequence
Date: Mon, 18 Dec 2017 12:37:13 -0500
Message-ID: <480d3e9c-a7b0-46c7-6744-6aa5b4a75635@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([205.185.120.7]:43276 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758087AbdLRSLd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Dec 2017 13:11:33 -0500
Received: from [IPv6:2601:6c5:8000:1480:54ff:ba2b:b29:792c] ([IPv6:2601:6c5:8000:1480:54ff:ba2b:b29:792c])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id vBIHbGrN021127
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
        for <linux-bcache@vger.kernel.org>; Mon, 18 Dec 2017 12:37:18 -0500
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I'm noticing that, with Fedora, dracut is trying to stop the mdraid 
devices before bcache stops.

> [ 1378.484141] dracut: Waiting for mdraid devices to be clean.
> [ 1378.494073] dracut: Disassembling mdraid devices.
> mdadm: Cannot get exclusive access to /dev/md1:Perhaps a running 
> process, mounted filesystem or active volume group?
> mdadm: Cannot get exclusive access to /dev/md0:Perhaps a running 
> process, mounted filesystem or active volume group?
> mdadm: Cannot get exclusive access to /dev/md1:Perhaps a running 
> process, mounted filesystem or active volume group?
> mdadm: Cannot get exclusive access to /dev/md0:Perhaps a running 
> process, mounted filesystem or active volume group?
> Powering off.
> [ 1379.582761] bcache: bcache_reboot() Stopping all devices:
> [ 1379.728768] bcache: bcache_device_free() bcache0 stopped
> [ 1379.781601] bcache: cache_set_free() Cache set 
> 4772d958-3d94-4411-b26c-86206cfa551e unregistered
> [ 1379.792585] bcache: bcache_reboot() All devices stopped

I haven't seen any data loss or corruption so this doesn't seem to be a 
problem but it would be nice to have bcache stop first so I don't get so 
alarmed by these messages.

How is the shutdown sequence for bcache controlled? Where can I find the 
relevant code?

--Larkin

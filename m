From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: caching device setup
Date: Wed, 08 Apr 2015 20:56:41 +0200
Message-ID: <98agvb-l7r.ln1@hurikhan77.spdns.de>
References: <CAK1hC9vTG=TEsUzNgxym=+0swhPoxBNaaPAiWk1kBf-D+_Hftg@mail.gmail.com> <498317a297a1038028f1393da9b49231@de.mcbf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57706 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbbDHS4t (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Apr 2015 14:56:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1Yfv9c-0007MF-A1
	for linux-bcache@vger.kernel.org; Wed, 08 Apr 2015 20:56:48 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 08 Apr 2015 20:56:48 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 08 Apr 2015 20:56:48 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

David Mohr <david@mcbf.net> schrieb:

> On 2015-04-06 09:44, arnaud gaboury wrote:
>> Here is my overall plan:
>> 
>> root filesystem & OS on a SSD
>> DB and other stuff on HD.
>> Use ssd as caching device and HD as backing.
>> 
>> Shall I partition the SSD with : one partition for OS and one empty
>> for bcache? Or install the OS on the whole SSD and use the whole SSD
>> as caching device?
>> 
>> Thank you for hint.
> 
> So this is just depending on your preference, how big the SSD is, and
> how much space you expect your OS to take up.
> 
> Personally I split my SSD into two partitions: one for the root FS, and
> the other as a caching device for /home.

The other preference is valid, too: I chose to put bcache only on the SSD to 
get maximum benefit from its capacity, rootfs and home dynamically share the 
cache then depending on demands. So rootfs is a bit slower as natively on 
SSD but home can gain much more because unsed parts of the rootfs are 
available for caching.

The split-setup preference in turn gives you a fallback boot option in case 
bcache chokes: You still have a working rootfs to do repairs or restore 
backups. In my setup I encounter that problem with a working USB3-HD mirror 
of my system I can boot and restore from which is synced and snapshotted 
every night (so it also protects against accidental file deletion synced 
undetected into the backup). Most valuable data is stored remotely (photos, 
source code, documents, configuration, etc).

-- 
Replies to list only preferred.

From: Jason Warr <jason@warr.net>
Subject: Re: Another bcache hang
Date: Fri, 22 Nov 2013 08:35:25 -0600
Message-ID: <528F6BAD.7080703@warr.net>
References: <20131121135604.GA26424@professorx.home.zettazebra.com> <14da01cee71f$28d233f0$7a769bd0$@acm.org> <20131122034919.GA25040@professorx.home.zettazebra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:55648 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752132Ab3KVOoH (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 Nov 2013 09:44:07 -0500
Received: from smtprelay.hostedemail.com (ff-bigip1 [10.5.19.254])
	by smtpgrave04.hostedemail.com (Postfix) with ESMTP id BFBEFB24AC
	for <linux-bcache@vger.kernel.org>; Fri, 22 Nov 2013 14:36:09 +0000 (UTC)
In-Reply-To: <20131122034919.GA25040@professorx.home.zettazebra.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "David H. Rhodes Clymer" <david@zettazebra.com>
Cc: "Paul B. Henson" <henson@acm.org>, linux-bcache@vger.kernel.org


On 11/21/2013 09:49 PM, David H. Rhodes Clymer wrote:
> On Thu, Nov 21, 2013 at 05:07:02PM -0800, Paul B. Henson wrote:
>>> From: David H. Rhodes Clymer
>>> Sent: Thursday, November 21, 2013 5:56 AM
>>>
>>> I have two bcache devices with different backing devices, but with shared
>>> cache. The backing devices are LVM logical volumes on top of an RAID1
>>> software raid device (/dev/md2). The filesystem is ext4.
>> Off-topic, sorry, but if I understand you your layering is:
>>
>> disks - mdraid - lvm - bcache - filesystem?
>>
>> So you created an lv which is the backing device for bcache?
>>
>> I've been looking at using bcache, but I was planning on switching the
>> ordering and putting bcache on top of the mdraid, then creating a pv for lvm
>> on the bcache device:
>>
>> disks - mdraid - bcache - lvm - filesystem
>>
>> Out of curiosity, I was wondering why you layered the other way.
> Laziness, mostly. The RAID1 array is a PV that houses filesystems we'd
> rather thot lose. The development databases are not so critical - we
> rebuild them at least once a week anyway. The use of LVs was a quick
> and easy way to test various caching implementations without increasing
> the risk of data loss or corruption in the rest of the system.
>
> If you want to provide a block cache for all of your logical volumes,
> it would make much more sense to put LVM on top of bcache rather than
> the other way around.

As I start to use more LVM based RAID, and with it fault allocation
policy's, logically it makes more sense to setup individual volumes as
backing stores instead of PV's.  That way you always know your caching
the volumes you want no matter what PV device(s) they are sitting on.

That's really one of the great things about this.  You can pick what
target you use as a backing store depending on your performance and
management needs.  There is no one right way to do this.

>
> -davidc
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

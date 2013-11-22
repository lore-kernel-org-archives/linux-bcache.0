From: Jason Warr <jason@warr.net>
Subject: Re: Another bcache hang
Date: Fri, 22 Nov 2013 14:34:22 -0600
Message-ID: <528FBFCE.7020104@warr.net>
References: <20131121135604.GA26424@professorx.home.zettazebra.com> <14da01cee71f$28d233f0$7a769bd0$@acm.org> <20131122034919.GA25040@professorx.home.zettazebra.com> <528F6BAD.7080703@warr.net> <156301cee7bc$3b7fc420$b27f4c60$@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:48014 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755875Ab3KVUeZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 Nov 2013 15:34:25 -0500
In-Reply-To: <156301cee7bc$3b7fc420$b27f4c60$@acm.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Paul B. Henson" <henson@acm.org>
Cc: linux-bcache@vger.kernel.org


On 11/22/2013 01:51 PM, Paul B. Henson wrote:
>> From: Jason Warr [mailto:jason@warr.net]
>> Sent: Friday, November 22, 2013 6:35 AM
>>
>> As I start to use more LVM based RAID, and with it fault allocation
>> policy's, logically it makes more sense to setup individual volumes as
>> backing stores instead of PV's.  That way you always know your caching
>> the volumes you want no matter what PV device(s) they are sitting on.
> I looked at LVM raid once a while ago, it didn't really seem quite there
> yet. I haven't checked recently, do you consider it a better choice than
> classic md raid now? It would be one less layer in the stack, but mdraid has
> been pretty bulletproof for me for quite some time and I'd be hesitant to
> switch.
>

I would say it is going to be a better choice for use cases that are
more dynamic in nature.  By that I mean where you may have a larger
number of smaller volumes that may have different needs for redundancy
and/or where you may be adding or removing physical devices often.

LVM RAID, not to be confused with LVM mirroring or striping, gives you
more flexibility in extent placement than what you have if you use MD
RAID.  From what I understand the LVM RAID code comes directly from the
MD RAID code so it should be just as reliable as MD but give you more
volume level flexibility.  There is obviously some serious performance
constraints that can come up if you mix RAID types on the same set of
physical disks but this is one place where bcache can come in and help.

MD RAID will still be the option of choice for me in cases where I have
a single large volume that will span multiple PV's such as a multi
terabyte media repository.  Although since overall performance is not
terribly important for me there it may make more sense to just use LVM
RAID to keep it all in the same layer.

There are lots of good options that are becoming more viable now that we
have a real in kernel caching device to mask out allot of previous
performance concerns.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

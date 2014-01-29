From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Moving a backing device between 2 cachesets
Date: Wed, 29 Jan 2014 17:01:52 +0000 (UTC)
Message-ID: <lcbc60$ola$2@ger.gmane.org>
References: <338c5bf03af2422ab712a3552c981390@navex1.navixia.local> <
	lcalu5$iek$1@ger.gmane.org> <56b62eb646f94bbe868ae6b2f26d94e8@navex1.
	navixia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37393 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaA2RCY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 29 Jan 2014 12:02:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1W8YWr-0004W2-Et
	for linux-bcache@vger.kernel.org; Wed, 29 Jan 2014 18:02:21 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jan 2014 18:02:21 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jan 2014 18:02:21 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

>> After flushing, detaching does two things:
>> - the backing device gets flagged as detached
>> - the backing device is removed from the cache set's metadata
>> (stored as uuid_entry in a special bucket; the entry is flagged
>> with a bogus uuid but not reused).  The offset in that uuids
>> array constitutes an id, local to the cache set, that is not
>> reused after detaching.
>>
>> The second step invalidates the backing device's id in the cache set,
>> and indirectly invalidates all buckets that referenced it (through
>> bkey->inode in the bucket key).
> 
> I understand that we are safe, then. Right ? 

tl;dr: after looking at the code, I expect you'll be fine

That's what I expected anyway (iirc these non-reusable ids appear
somewhere, maybe logs), I just spent a little more time checking.

> Thanks for your clarifications

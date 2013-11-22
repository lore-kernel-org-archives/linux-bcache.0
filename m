From: "David H. Rhodes Clymer" <david@zettazebra.com>
Subject: Re: Another bcache hang
Date: Thu, 21 Nov 2013 22:49:19 -0500
Message-ID: <20131122034919.GA25040@professorx.home.zettazebra.com>
References: <20131121135604.GA26424@professorx.home.zettazebra.com>
 <14da01cee71f$28d233f0$7a769bd0$@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qe0-f47.google.com ([209.85.128.47]:50288 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3KVDt5 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 21 Nov 2013 22:49:57 -0500
Received: by mail-qe0-f47.google.com with SMTP id t7so552109qeb.6
        for <linux-bcache@vger.kernel.org>; Thu, 21 Nov 2013 19:49:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <14da01cee71f$28d233f0$7a769bd0$@acm.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Paul B. Henson" <henson@acm.org>
Cc: linux-bcache@vger.kernel.org

On Thu, Nov 21, 2013 at 05:07:02PM -0800, Paul B. Henson wrote:
> > From: David H. Rhodes Clymer
> > Sent: Thursday, November 21, 2013 5:56 AM
> >
> > I have two bcache devices with different backing devices, but with shared
> > cache. The backing devices are LVM logical volumes on top of an RAID1
> > software raid device (/dev/md2). The filesystem is ext4.
> 
> Off-topic, sorry, but if I understand you your layering is:
> 
> disks - mdraid - lvm - bcache - filesystem?
> 
> So you created an lv which is the backing device for bcache?
> 
> I've been looking at using bcache, but I was planning on switching the
> ordering and putting bcache on top of the mdraid, then creating a pv for lvm
> on the bcache device:
> 
> disks - mdraid - bcache - lvm - filesystem
> 
> Out of curiosity, I was wondering why you layered the other way.

Laziness, mostly. The RAID1 array is a PV that houses filesystems we'd
rather thot lose. The development databases are not so critical - we
rebuild them at least once a week anyway. The use of LVs was a quick
and easy way to test various caching implementations without increasing
the risk of data loss or corruption in the rest of the system.

If you want to provide a block cache for all of your logical volumes,
it would make much more sense to put LVM on top of bcache rather than
the other way around.

-davidc

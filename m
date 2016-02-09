From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: bcache and LVM
Date: Tue, 09 Feb 2016 11:44:52 +0100
Message-ID: <20160209114452.Horde.0AlUHBhWkB7dDF8j0jmv3SL@www3.nde.ag>
References: <87k2mgo2rz.fsf@vostro.rath.org>
 <20160208144419.Horde.Ci1_2KcBCEnOa-WxsDN90oU@www3.nde.ag>
 <87r3gmrhbn.fsf@thinkpad.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:42363 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbcBIKoz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 9 Feb 2016 05:44:55 -0500
In-Reply-To: <87r3gmrhbn.fsf@thinkpad.rath.org>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: linux-bcache@vger.kernel.org

Hi Nikolaus,

Zitat von Nikolaus Rath <Nikolaus@rath.org>:
> On Feb 08 2016, "Jens-U. Mozdzen" <jmozdzen@nde.ag> wrote:
>> [...]
>> The article itself does positively mention sub-dividing bcache devices
>> using LVM.
>
> Yep, but the talk page then says:
>
> | Initially, LVM did not recognize my /dev/bcache0 when I wanted to
> | create a physical volume on it. For anyone else who has that issue,
> | this may be relevant:
> | http://www.redhat.com/archives/linux-lvm/2012-March/msg00005.html.

this still holds true even with LVM on OpenSUSE Leap 42.1 (which is  
what we're using ATM) - but that's no "stability issue", but rather an  
installation nuisance. You only need to tell LVM to consider bcache  
devices at all, by extending /etc/lvm/lvm.conf.

> Thanks for the datapoint! What kernel version do you use?

4.1.13-5-default #1 SMP PREEMPT Thu Nov 26 16:35:17 UTC 2015 (49475c3)  
x86_64 x86_64 x86_64 GNU/Linux

It's the kernel from the OpenSUSE project repository, no further  
patches applied by me:

Source Timestamp: 2015-11-26 17:35:17 +0100
GIT Revision: 49475c39bfd2ee30d145707df8a17419822ba804
GIT Branch: users/tiwai/openSUSE-42.1/for-next
Distribution: openSUSE Leap 42.1

Regards,
Jens

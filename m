From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: bcache and hibernation
Date: Tue, 10 Feb 2015 23:36:38 +0100
Message-ID: <nodqqb-lh4.ln1@hurikhan77.spdns.de>
References: <87h9y3xl6l.fsf@bluescreen303.nl> <878ujfxflg.fsf@bluescreen303.nl> <CAPBO7TZF5qUV64UZJVE+WQkKa2aCJSTjkQxh6eVktH7nA41Vqw@mail.gmail.com> <874mu3xcum.fsf@bluescreen303.nl> <CAPBO7TbQA2MbFS43racKOwZ+=U2jC4OcLF413-MvvNKML5=QZQ@mail.gmail.com> <87zjbvvwtd.fsf@bluescreen303.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35916 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbbBJW5L (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 10 Feb 2015 17:57:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YLJjx-0005hm-W3
	for linux-bcache@vger.kernel.org; Tue, 10 Feb 2015 23:57:10 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 10 Feb 2015 23:57:09 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 10 Feb 2015 23:57:09 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Mathijs Kwik <mathijs@bluescreen303.nl> schrieb:

>> System boots as usual, but during kernel boot it finds a hibernation in
>> swap area and just restores it.
> 
> I understand how suspend works. My question is regarding the steps
> _before_ finding the hibernation image. My guess is there are situations
> where detecting/activating a bcache device before restoring the
> hibernation image can lead to disaster.
> 
> So either this is not the case (I would like an explanation why), or I
> need a way to make sure udev does not register bcache before resuming.

Are you sure that user space runs before the resume image is loaded? I know 
that initrd could do that but as far as I see, if you supply the resume 
option to the kernel cmdline, the kernel will take care of resuming before 
initrd userspace does it - which should pretty well circumvent your problem.

BTW: I'm using the resume= option and had no problem with hibernation. It 
seems to work fine.

-- 
Replies to list only preferred.

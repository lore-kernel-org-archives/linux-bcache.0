From: Vlad <vovan@vovan.nl>
Subject: Re: Adding net cache device to existing bcache
Date: Wed, 18 Dec 2013 19:30:24 +0100
Message-ID: <52B1E9C0.1030807@net.home>
References: <52B1E6B8.3080103@net.home> <CALJ65znXOa80Yp4Ah69DvkyyiQ0fkVAmi4L_3A+cMeQ0xzzjcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 77-175-29-125.FTTH.ispfabriek.nl ([77.175.29.125]:42572 "EHLO
	srv2.net.home" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753427Ab3LRSa0 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 Dec 2013 13:30:26 -0500
Received: from localhost (localhost [127.0.0.1])
	by srv2.net.home (Postfix) with ESMTP id 64B9220A683
	for <linux-bcache@vger.kernel.org>; Wed, 18 Dec 2013 19:30:25 +0100 (CET)
Received: from srv2.net.home ([127.0.0.1])
	by localhost (webmail.net.home [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ynA0voFyvWNH for <linux-bcache@vger.kernel.org>;
	Wed, 18 Dec 2013 19:30:25 +0100 (CET)
Received: from [192.168.1.2] (vovan.net.home [192.168.1.2])
	(Authenticated sender: vovan)
	by srv2.net.home (Postfix) with ESMTPSA id 1A52020A67D
	for <linux-bcache@vger.kernel.org>; Wed, 18 Dec 2013 19:30:25 +0100 (CET)
In-Reply-To: <CALJ65znXOa80Yp4Ah69DvkyyiQ0fkVAmi4L_3A+cMeQ0xzzjcw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

After I issue "make-bcache --cache /dev/sdf3" instantly the new bcache
without backing device is registered. This could be fixed by echoing to
/sys/fs/bcache/<NEW_DEV_UUID>/stop. But I still can't attach the new
device  by doing "echo UUID >/sys/block/bcache0/bcache/attach".
I've tried to use "make-bcache --cset-uuid <EXISTING_UUID> --cache
--wipe-bcache /dev/sdf3", but kernel complains that the device already
exists.

Regards,
Vlad.

On 18/12/13 19:23, Kent Overstreet wrote:
> Can you list the commands you were using?
>
> On Wed, Dec 18, 2013 at 10:17 AM, Vlad <vovan@vovan.nl> wrote:
>> Hello,
>>
>> I'm trying to add new cache device to an existing bcache, but
>> unsuccessfully... I thought it should as simple as formating the new
>> cache device (make-bcache) and then attaching it to an existing bcache
>> device. However, this procedure won't work.
>> Is there any useful howto or another info about this subject.
>>
>> Regards,
>> Vlad.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

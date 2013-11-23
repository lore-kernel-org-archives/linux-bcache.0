From: Jason Warr <jason@warr.net>
Subject: Re: Another bcache hang
Date: Fri, 22 Nov 2013 19:02:40 -0600
Message-ID: <528FFEB0.1050704@warr.net>
References: <20131121135604.GA26424@professorx.home.zettazebra.com> <14da01cee71f$28d233f0$7a769bd0$@acm.org> <20131122034919.GA25040@professorx.home.zettazebra.com> <528F6BAD.7080703@warr.net> <156301cee7bc$3b7fc420$b27f4c60$@acm.org> <528FBFCE.7020104@warr.net> <001b01cee7dd$e82f5d90$b88e18b0$@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:42131 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755635Ab3KWBCo (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 Nov 2013 20:02:44 -0500
In-Reply-To: <001b01cee7dd$e82f5d90$b88e18b0$@acm.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Paul B. Henson" <henson@acm.org>
Cc: linux-bcache@vger.kernel.org


On 11/22/2013 05:52 PM, Paul B. Henson wrote:
>> From: Jason Warr [mailto:jason@warr.net]
>> Sent: Friday, November 22, 2013 12:34 PM
>>
>> I would say it is going to be a better choice for use cases that are
>> more dynamic in nature.  By that I mean where you may have a larger
>> number of smaller volumes that may have different needs for redundancy
>> and/or where you may be adding or removing physical devices often.
> Ah, that's true; using raid at the lvm layer allows you to selectively
> choose redundancy as opposed to dropping the entire pv on top of an mdraid.
>
>> There are lots of good options that are becoming more viable now that we
>> have a real in kernel caching device to mask out allot of previous
>> performance concerns.
> Continuing to veer off-topic ;), what kernel version are you currently using
> with bcache? I was originally thinking of going 3.10LTS, but ended up
> installing 3.11 based on the mailing list traffic.
>

Actually that is probably veering back on topic :)

At the moment I am using Fedora 20 Beta's version of 3.11.8.  I don't
yet have enough time with it to say how useful/stable it is.  I try to
stick with something that has a better chance of making it into an
enterprise distro as that is my main focus.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

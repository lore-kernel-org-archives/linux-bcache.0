From: Jason Warr <jason@warr.net>
Subject: Re: Another bcache hang
Date: Fri, 22 Nov 2013 20:38:31 -0600
Message-ID: <52901527.9010309@warr.net>
References: <20131121135604.GA26424@professorx.home.zettazebra.com> <14da01cee71f$28d233f0$7a769bd0$@acm.org> <20131122034919.GA25040@professorx.home.zettazebra.com> <528F6BAD.7080703@warr.net> <156301cee7bc$3b7fc420$b27f4c60$@acm.org> <528FBFCE.7020104@warr.net> <001b01cee7dd$e82f5d90$b88e18b0$@acm.org> <528FFEB0.1050704@warr.net> <001f01cee7f1$bd65e7f0$3831b7d0$@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:37524 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755981Ab3KWCif (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 Nov 2013 21:38:35 -0500
In-Reply-To: <001f01cee7f1$bd65e7f0$3831b7d0$@acm.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Paul B. Henson" <henson@acm.org>
Cc: linux-bcache@vger.kernel.org


On 11/22/2013 08:14 PM, Paul B. Henson wrote:
>> From: Jason Warr
>> Sent: Friday, November 22, 2013 5:03 PM
>>
>> Actually that is probably veering back on topic :)
> Well, for the list maybe, but not for the thread, which has still not seen
> any debugging/troubleshooting recommendations for the bcache hang originally
> reported.
>
>> At the moment I am using Fedora 20 Beta's version of 3.11.8.  I don't
>> yet have enough time with it to say how useful/stable it is.  I try to
>> stick with something that has a better chance of making it into an
>> enterprise distro as that is my main focus.
> I generally run Gentoo unless there is a proprietary commercial application
> involved, in which case we use RHEL. I can't see this being backported to
> RHEL6, but possibly it might show up in RHEL7. I guess there's no firm
> release date on that yet, but scuttlebutt has it that they will be using
> kernel 3.11 (although I don't think that's intended to be an upstream LTS
> kernel), which matches the current development fedora version...
I would say there is exactly zero hope of anything exciting coming onto
RHEL6 at this point.  My hope is that bcache will at least be a "tech
preview" feature in RHEL7.  With the RHEL6.5 spin just dropping I sure
hope they give us some more solid direction soon on what RHEL7 should
look like.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

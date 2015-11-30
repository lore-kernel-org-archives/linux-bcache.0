From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Mon, 30 Nov 2015 07:07:43 +0000
Message-ID: <20151130070743.11343yqeihgbzfsv@imap.suse.de>
References: <1448626993.2877.112.camel@suse.de>
 <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net>
 <1447419912.2616.19.camel@suse.de> <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
 <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
 <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net>
 <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net>
 <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbbK3HHp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 30 Nov 2015 02:07:45 -0500
In-Reply-To: <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Yannis Aribaud <bugs@d6bell.net>, linux-bcache@vger.kernel.org

Hi Eric,

Zitat von Eric Wheeler <bcache@lists.ewheeler.net>:

>
> (intentional top-post)
>
> There are a number of stability patches that haven't found their way =
to
> mainstream yet.  We have been using bcache for over a year now with g=
reat
> stability and no dataloss with these patches.  Try pulling the branch=
 that
> I just set up to maintain these commits:
>

Thanks for pointing us at these patches. Yannis can you give them a try=
?
Regarding the maintainance situation, does anyone know when/if Kent =20
will pick up these patches? If not we should try to get them to Linus =20
via some other path (maybe Andrew or Jens).


> https://github.com/ewheelerinc/linux/commits/bcache-patches-for-3.17
>
> git add remote ewheelerinc https://github.com/ewheelerinc/linux.git
> git fetch ewheelerinc
> git merge ewheelerinc/bcache-patches-for-3.17
>
> This is a clone of Linus's tree circa 3.17-rc1 so git merge should br=
ing
> this in cleanly to any later branch.  You could cherry-pick as well.
> I've tested and this will also merge cleanly into v4.1.13.
>
> Note that I've not written any of these patches, I just keep them aro=
und
> since they make the difference between stable and unstable for bcache=
=2E
> The original authors and their discussions are included in the commit
> notes.
>
>
>
>
> --
> Eric Wheeler, President           eWheeler, Inc. dba Global Linux Sec=
urity
> 888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box =
25107
> www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR =
97298
>
> On Fri, 27 Nov 2015, Yannis Aribaud wrote:
>
>> 27 novembre 2015 13:23 "Johannes Thumshirn" <jthumshirn@suse.de> a =C3=
=A9crit:
>> > Sorry to disappoint you, but I couldn't find anything that could =20
>> be related to
>> > your lockup.
>>
>> Well even I you didn't found anything, thank you for your time.
>>
>> I just upgraded my kernel to 4.2.6 vanilla to see if this lockup =20
>> occurs again.
>>
>> Regards,
>> --
>> Open is better
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcac=
he" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

From: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: Re: caching device setup
Date: Mon, 6 Apr 2015 19:44:30 +0200
Message-ID: <CAK1hC9upqSZG14A6dabgdiPh4WkHLXWkoNMJeLH3Ym5oqcC1qA@mail.gmail.com>
References: <CAK1hC9vTG=TEsUzNgxym=+0swhPoxBNaaPAiWk1kBf-D+_Hftg@mail.gmail.com>
	<CAPBO7TY13PYVh3d0bt3tkc_+_vJVybCy-kBBT223VfPmQkjuWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35320 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbbDFRoc (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 6 Apr 2015 13:44:32 -0400
Received: by lbbuc2 with SMTP id uc2so21360936lbb.2
        for <linux-bcache@vger.kernel.org>; Mon, 06 Apr 2015 10:44:31 -0700 (PDT)
In-Reply-To: <CAPBO7TY13PYVh3d0bt3tkc_+_vJVybCy-kBBT223VfPmQkjuWw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Josep Lladonosa <jlladono@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Apr 6, 2015 at 6:03 PM, Josep Lladonosa <jlladono@gmail.com> wrote:
>
> On 6 Apr 2015 17:46, "arnaud gaboury" <arnaud.gaboury@gmail.com> wrote:
>>
>> Here is my overall plan:
>>
>> root filesystem & OS on a SSD
>> DB and other stuff on HD.
>> Use ssd as caching device and HD as backing.
>>
>> Shall I partition the SSD with : one partition for OS and one empty
>> for bcache? Or install the OS on the whole SSD and use the whole SSD
>> as caching device?
>
> You need a specific partition as a caching device for bcache.

Thank you.


>>
>> Thank you for hint.
>>
>> --
>>
>> google.com/+arnaudgabourygabx
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 

google.com/+arnaudgabourygabx

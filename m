From: Thomas Rosenstein <thomas@ccs.at>
Subject: Re: Bcache file corruption
Date: Wed, 8 Feb 2017 07:45:57 +0100
Message-ID: <DC5D87AB-B603-4E8D-BBFF-F1FA063EB6EF@ccs.at>
References: <20170207155956.Horde.j9Dv5b4PsA33ZMsJPwC5UA8@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed; markup=markdown
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-db5eur01on0137.outbound.protection.outlook.com ([104.47.2.137]:11370
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752924AbdBHGqq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Feb 2017 01:46:46 -0500
In-Reply-To: <20170207155956.Horde.j9Dv5b4PsA33ZMsJPwC5UA8@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-bcache@vger.kernel.org

Hi Jens,

Linux host 4.9.8 #1 SMP Tue Feb 7 19:15:34 UTC 2017 x86_64 x86_64 x86_64 
GNU/Linux

Fixed the issue, could restore the whole DB and it could catch up.

Thanks, maybe someone could add a warning? 😊

Regards
Thomas

On 7 Feb 2017, at 15:59, Jens-U. Mozdzen wrote:

> Hi Thomas,
>
> Zitat von Thomas Rosenstein <thomas@ccs.at>:
>> Hi,
>>
>> I'm trying to run bcache on a Hyper-V VM, following setup:
>> [...]
>> Linux host 3.10.0-514.6.1.el7.x86_64 #1 SMP Wed Jan 18 13:06:36 UTC 
>> 2017 x86_64 x86_64 x86_64 GNU/Linux
>>
>> I compiled bcache as a module according to: 
>> http://10sa.com/sql_stories/?p=1052
>
> what catches the eye is the old kernel version. While many fixes may 
> have been back-ported by the distro developers, I have no idea to what 
> extend this was actually done. I remember having seen quite a number 
> of severe bugs, i.e. in the disk subsystem, that may well have lead to 
> the problems you face.
>
> Are you in a position to boot a more recent (mainline) kernel for a 
> test, if just to compare results?
>
> Regards,
> Jens

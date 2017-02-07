From: Thomas Rosenstein <thomas@ccs.at>
Subject: Re: Bcache file corruption
Date: Tue, 7 Feb 2017 16:01:42 +0100
Message-ID: <269ED917-2CAF-496A-9BA6-A6A77396353B@ccs.at>
References: <20170207155956.Horde.j9Dv5b4PsA33ZMsJPwC5UA8@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; markup=markdown
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-db5eur01on0109.outbound.protection.outlook.com ([104.47.2.109]:2752
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754571AbdBGPBt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Feb 2017 10:01:49 -0500
In-Reply-To: <20170207155956.Horde.j9Dv5b4PsA33ZMsJPwC5UA8@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-bcache@vger.kernel.org

Hi Jens,

guess I can do that, elrepo has 4.4 as far as I know, so I guess this 
could be worth a try!

Thanks, will report back after another 600GB restore

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

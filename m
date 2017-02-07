From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: Bcache file corruption
Date: Tue, 07 Feb 2017 15:59:56 +0100
Message-ID: <20170207155956.Horde.j9Dv5b4PsA33ZMsJPwC5UA8@www3.nde.ag>
References: <93B8FFF8-6FC1-4DE6-AD80-EDC7180C670F@ccs.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:26094 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754007AbdBGPAB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Feb 2017 10:00:01 -0500
In-Reply-To: <93B8FFF8-6FC1-4DE6-AD80-EDC7180C670F@ccs.at>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Thomas Rosenstein <thomas@ccs.at>
Cc: linux-bcache@vger.kernel.org

Hi Thomas,

Zitat von Thomas Rosenstein <thomas@ccs.at>:
> Hi,
>
> I'm trying to run bcache on a Hyper-V VM, following setup:
> [...]
> Linux host 3.10.0-514.6.1.el7.x86_64 #1 SMP Wed Jan 18 13:06:36 UTC  
> 2017 x86_64 x86_64 x86_64 GNU/Linux
>
> I compiled bcache as a module according to:  
> http://10sa.com/sql_stories/?p=1052

what catches the eye is the old kernel version. While many fixes may  
have been back-ported by the distro developers, I have no idea to what  
extend this was actually done. I remember having seen quite a number  
of severe bugs, i.e. in the disk subsystem, that may well have lead to  
the problems you face.

Are you in a position to boot a more recent (mainline) kernel for a  
test, if just to compare results?

Regards,
Jens

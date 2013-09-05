From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-tools package for Fedora / status probe-bcache
Date: Thu, 05 Sep 2013 08:53:59 +0200
Message-ID: <52282A87.4000801@rolffokkens.nl>
References: <521A55D4.20908@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521A55D4.20908-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

Packaging is progressing well, an initial package is available: 
https://admin.fedoraproject.org/updates/bcache-tools-0-0.9.20130827git.fc20

probe-bcache is part of this package, but util-linux will obsolete this 
shortly: https://bugzilla.redhat.com/show_bug.cgi?id=1001120#c13 
Actually the blkid utility in util-linux will do a more thorough job on 
identifying bcache, e.g. by also checking the csum. Having blkid 
identify bcache also simplifies the bcache udev rules.

So now I'm wondering: are there any particular reasons to keep 
probe-bcache part of the package, or will it really be obsolete?

Rolf

On 08/25/2013 09:07 PM, Rolf Fokkens wrote:
> Hi!
>
> To allow Fedora users to benefit from bcache I'm currently packaging 
> bcache-tools for Fedora.
>
> See also: https://bugzilla.redhat.com/show_bug.cgi?id=999690
>
> Any suggestions or other feedback is welcome. Whenever I run into 
> something relevant, I'll share it with the mail list.
>
> Rolf Fokkens
>

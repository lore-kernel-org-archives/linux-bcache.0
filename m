From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: [RFC] bcache-status
Date: Mon, 26 Aug 2013 22:36:11 +0200
Message-ID: <521BBC3B.9010003@rolffokkens.nl>
References: <521A55D4.20908@rolffokkens.nl> <521A6B92.60001@rolffokkens.nl> <20130826163055.GB4780@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130826163055.GB4780-yuuUpGxbzT9UbpRmUfBrXUB+6BGkLq7r@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 08/26/2013 06:30 PM, Darrick J. Wong wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=999690#c12
>
> I have a few questions/remarks:
> - Is the python3 dependency really needed? I changed it to ordinary
> python(2) and it runs fine I think.
> Not required; I'm merely writing new scripts in python3.  (At least when I can
> find py3 libraries...)  I didn't write anything py3-specific, as far as I know.
Would you consider putting python in the header instead of python3? 
Having python3 in the heading adds the requirement to install python3, 
and I think python2 is (still) more standard. For Fedora 20 I think it 
is anyway, which means I have to patch it everytime I want to package it.
> For now, there's: https://gist.github.com/djwong/6343451 in which I've merged
> all the changes made by the two people who (thank you both!) provided
> modifications.
>
> Yeah, I fixed that before posting the gist. :) --D 
Thanks, I'll update the package!

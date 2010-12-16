From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: comparison with rival projects
Date: Wed, 15 Dec 2010 16:49:15 -0800
Message-ID: <4D09620B.7060405@gmail.com>
References: <1474160620.28501292460406484.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474160620.28501292460406484.JavaMail.root@shiva>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org
Cc: Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, info-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 12/15/2010 04:46 PM, luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org wrote:
> First of all, I would like to thanks for answers.
>
> One more question and some reply in text.
>
> After making ssd disc a cache for some partition, there is possibility to detach cache. What should I do to "erase" (trim) whole disk for another benchmarking? I think that "dd if=/dev/zero of=/dev/sdx" wouldnt be right command.

Yeah, one nifty thing is you can disable caching on a mounted, in use 
filesystem (and reenable it provided you invalidate the cache somehow).

Hdparm can send a trim, but it can't do the whole disk at once, you've 
got to script it. I wrote one awhile back, this is what I use:

#!/bin/bash

DEV=$1

if [ ! -b "$DEV" ]; then
         echo "Can't open $DEV"
         exit 1
fi

SECTORS=`hdparm -I "$DEV"|awk '/LBA48/ { print $5 }'`
OFFSET=0

echo "$DEV has $SECTORS sectors:"

while (($SECTORS)); do
         i=$(( $SECTORS > 65535 ? 65535 : $SECTORS ))

         echo "wiping $i sectors at offset $OFFSET"
         hdparm --please-destroy-my-drive \
		--trim-sector-ranges $OFFSET:$i $DEV

         SECTORS=$(($SECTORS - $i))
         OFFSET=$(($OFFSET + $i))
done
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

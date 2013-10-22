From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache not working on large files?
Date: Tue, 22 Oct 2013 19:35:48 +0200
Message-ID: <5266B774.6040202@rolffokkens.nl>
References: <20131022070830.GA20286@euve30603.vserver.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131022070830.GA20286-TGNR7510c4H9eX/OD4jYIkzuTB+3w3uf@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dirk Geschke <dirk-WMiem5eIfR0n5izryJqWLw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Dirk,

On 10/22/2013 09:08 AM, Dirk Geschke wrote:
> I was just playing a little bit with bcache and it works fine. But
> if I try random IOPS writes (writeback) on a file larger than the
> cache, it seems not to work? At least I get a performance as without
> bcache.
>
> Did I miss something? Is caching disabled in such cases?
>
> Has anyone a hint for me, what is going wrong?
Bcache has some specific handling of sequential I/O:

http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt

Could this explain what you're seeing?

Rolf

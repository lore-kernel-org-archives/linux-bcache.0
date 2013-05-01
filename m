From: Leslie Basmid <leslie.basmid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Very poor performances with the bcache-for-upstream branch
Date: Wed, 1 May 2013 18:56:41 +0200
Message-ID: <CA+XuAn+Z-gxkfeE8D-A1-EJ4_QEBUqPJYfc40jevkJFbMzQ+Rw@mail.gmail.com>
References: <CA+XuAnK4nNOG_tSuuteDThbj5L+5xmDsxQLfrHj314z1fr+bUA@mail.gmail.com>
	<1367422594.24900.YahooMailClassic@web181502.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1367422594.24900.YahooMailClassic-XYahOdtEMNm2Y7dhQGSVAJOW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Matthew,

this is a very good question to start with. I am in fact very
surprised by two things:

1. The results I have on a cached filesystem are not that far away
from those I am getting from a not-cached FS;
2. The results I am getting as write performance seems very far from
those that are exposed for a similar benchmark
on bcache front page (accounting for tens of thousand IOPS).

I understand that my benchmark is done on a cached partition set up as
a LVM, and on a file laid out on a XFS formatted VG. This must have a
cost, but this huge ?
I also understand that the SSD on my laptop may have poorer
performances than the one used by Kent for his benchmark, yet the
difference is huge (18.5K >> 454). Hence my eyebrows rising...

Cheers,
Leslie.

On Wed, May 1, 2013 at 5:36 PM, matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
>> I am obtaining the following figures, on a cached fs:
>> seq-read: iops=12188
>> rand-read: iops=7392
>> seq-write: iops=430
>> rand-write: iops=454
>
> Just what numbers were you expecting to see? A decent 7200RPM drive can only muster 70 IOPs on a good day. The lies the SSD vendors print in their literature and on the side of the box are almost always done with a blocksize of 512 bytes. So if you're doing 4K operations, divide by 8 at least.

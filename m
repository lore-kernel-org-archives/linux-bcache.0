From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: how much of ssd to use?
Date: Sat, 02 Mar 2013 15:02:48 +0800
Message-ID: <5131A418.3080105@fnarfbargle.com>
References: <6035A0D088A63A46850C3988ED045A4B3876B655@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B3876B655-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 02/03/13 14:19, James Harper wrote:
> I've read that SSD drives work best when you only use some percentage of them (75%, 50%, etc) because by leaving unused space it allows the SSD more headroom to shuffle data around internally to keep things optimal. Those articles are most likely written for a filesystem on an OS that might not know about TRIM/UNMAP etc.
>
> Has anyone done any testing on sustained random write throughput on a (say) 60GB flash drive with only 50% dedicated to bcache, or 75%, or 100%?
>

SSD's use spare space to shuffle things around so they can reclaim space 
freed in sizes less than a full erase block. Bcache explicitly uses big 
buckets in such a way as to remove the requirement for this. Nothing is 
freed in a way that would cause fragmentation of the sector space, so no 
re-organising is required on the part of the drive.

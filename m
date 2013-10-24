From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: full ssd for bcache or part?
Date: Thu, 24 Oct 2013 12:08:07 +0800
Message-ID: <52689D27.7070500@fnarfbargle.com>
References: <CACaajQscOOajT2A6MNpstALph8D=jqdvqifynYxxR4gTXrGTGQ@mail.gmail.com> <f46b2a85-6116-4dac-8acd-03007110cf4b@email.android.com> <526884F8.4080000@fnarfbargle.com> <1382586002.46067.YahooMailNeo@web181505.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382586002.46067.YahooMailNeo-XYahOdtEMNnuQS8rMknbopOW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 10/24/2013 11:40 AM, matthew patton wrote:
>
>> I thought (and maybe I'm wrong) that a good chunk of reserved space was essential to allow the drive to efficiently manage its read-modify-write cycles.
>
> Correct. The industry ~standard of 7% (basically the difference between GiB and GB) is woefully inadequate for any kind of steady write load. ALL enterprise SSDs use north of 20% and and I've seen as high as 50%.

I must admit all my 250G SSDs are partitioned down to 200G.

>> It was my understanding that bcache was explicitly designed to fill erase block sized
>> chunks sequentially and discard them in whole units,
>> negating the requirement for the drive to actually perform RMW cycles
>
>
> RMW is an essential and inalienable of how an SSD works.

Well, yes... but. I'd have though if you don't give the drive a reason 
to perform an RMW, then it would be a reasonable assumption that perhaps 
it won't actually do one. Perhaps I give the firmware authors too much 
credit.

> Every manufacturer can use different page and erase block sizes. And much of the time they don't publish the specs publicly. So while Kent may have gone to deliberate length to optimize the way BCache does IO by using aligned, suitably large chunks (eg. 128KB-512KB) he has zero control over what the firmware decides to do.


This is essentially true, however making your storage bucket size big 
enough to believe it holds at least 1 full erase block would be a 
reasonable assumption. Oops.. ass-u-me..

> BTW, did you undo the retarded disk label that Linux has used for decades which is guaranteed to cause mis-aligned I/O? I expect BCache will start it's data area at 1MB offset from where the device starts. But it can't do much to remedy the  problem if you didn't align the partition or LV you handed BCache correctly to begin with.

I'm pretty sure all my drives are properly aligned. I learned that very 
quickly when I started using the WD "advanced format" drives, except for 
SSD's I align on 1M insteak of 4k.

I don't actually use bcache in production as when I did my last storage 
upgrade I just could not get it reliable (well before it hit the 
mainline kernel). I just keep tabs on it with the intention of using it 
when it develops the ability to mirror writeback data. In the mean time 
I'm just running on a RAID10 of 6 SSD's.

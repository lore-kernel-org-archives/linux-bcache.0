From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: can't get bache's sequential_cutoff to work
Date: Thu, 25 Jul 2013 09:17:16 +0200
Message-ID: <51F0D0FC.4040002@profihost.ag>
References: <51EE9056.7030903@profihost.ag> <CA+res+Ti1-tGANkb9wRAgF4sAcUqEv9RfGjDvbdX3bbxS=XK8g@mail.gmail.com> <51EEDC73.5020101@profihost.ag> <51EEE805.7090200@profihost.ag> <51EEE9D9.7090207@profihost.ag> <20130725001431.GA12364@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130725001431.GA12364@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: Jack Wang <jack.wang.usish-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Am 25.07.2013 02:14, schrieb Kent Overstreet:
> On Tue, Jul 23, 2013 at 10:38:49PM +0200, Stefan Priebe wrote:
>> Mhm works directly on block device but not with XFS on top.
> 
> That's odd...
> 
> Do you suppose you could look at what blktrace says is going down? If
> you could compare what blktrace says is going to the bcache device with
> and without XFS, hopefully that'll show what's going wrong...
> 
> Only thing I can think of that would cause it is for some reason XFS is
> sending bios down in the wrong order... which normally wouldn't be _too_
> painful since both the elevator and the disk's cache will reorder the
> IOs, so I can see how that would slip by.
Hi,

will try to have a look. But can it also be that the history of 128
entries is too small under my workload and bcache does not detect the
sequence? Is there a way to try with a higher value like 1024?

Stefan

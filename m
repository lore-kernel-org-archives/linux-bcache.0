From: Ryan Press <ryan-KcFX5CmBy0dzbRFIqnYvSA@public.gmane.org>
Subject: Re: Changing writeback_delay
Date: Sat, 5 Oct 2013 09:49:07 -0700
Message-ID: <CABx3TkUXyyCO9u4VBinE8=JuPqFAy56GgvmLkL8aWysX+TOexQ@mail.gmail.com>
References: <CABx3TkUS1TeBOzRY+E4TS7QsyORAaJNG6qy3FvEYQvHQ2+RbNw@mail.gmail.com>
	<CABx3TkXy0cAAXx+iFj8O11yD+jZGPh31rWqG-1f70ha+QhmCCg@mail.gmail.com>
	<1380991218.56343.YahooMailNeo@web181502.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380991218.56343.YahooMailNeo-XYahOdtEMNm2Y7dhQGSVAJOW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Matthew,

On Sat, Oct 5, 2013 at 9:40 AM, matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> Setting cache_mode to writeback and then setting both congested_[read/write]_threshold_us to 0 as you
> directed seems to do pretty much exactly what I want.  (at least it appears that almost all writes are going
> to cache first and then starts sending the data to the backing store about 30 seconds later as expected)

Yeah I want to change that 30 seconds to something much longer, like
one day.  In a perfect world, bcache could see when the drive is spun
up and write it opportunistically, or one day, whichever occurs first.

> thing is there's all kinds of partitions on your hard disk no doubt. Are they *ALL* unmounted or mounted RO except the bcache-enabled one?

I have the rootfs on the SSD (a different partition than bcache), so
on the hard disk there is only one partition and the one mount is the
bcache backing one.

Thanks,
Ryan

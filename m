From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: RE: Block Size for Windows
Date: Tue, 28 Aug 2012 00:59:11 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B29A75808@BITCOM1.int.sbss.com.au>
References: <503BC71A.6050207@abpni.co.uk>
 <CAH+dOxJ1GPQgmgDv4T3On-QovazSshU89GdVp=EHFmpaAzAGnQ@mail.gmail.com>
 <503BC82F.1030107@abpni.co.uk>
 <CAH+dOxJZEH9=ZEsB4RsS-8MdH-AGRh3jvo31bMUwXsMdirLMMQ@mail.gmail.com>
 <503BC897.3020606@abpni.co.uk>
 <CAH+dOxKx=kaW4duTyhRYrFH-5mYDUT6CGgY7WX9vqsMD_CpJaQ@mail.gmail.com>
 <503BCDC6.9010807@abpni.co.uk> <503BD1E8.7060402@abpni.co.uk>
 <503BD37C.9010403@abpni.co.uk> <503BD55D.2060408@abpni.co.uk>
 <CAOzFzEi6AzHFJVUGGc+J2p7QYe2f2i_XKrpad8wHDXo2xO=buA@mail.gmail.com>
 <503BEE7F.4020202@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503BEE7F.4020202-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> 
> On 27/08/2012 21:18, Joseph Glanville wrote:
> > On 28 August 2012 06:15, Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org> wrote:
> >> On 27/08/2012 21:07, Jonathan Tripathy wrote:
> >>> On 27/08/2012 21:00, Jonathan Tripathy wrote:
> >>>>
> >>>>> 2) The windows setup didn't complain that it couldn't install on
> >>>>> the LV, but once I clicked 'next', the Dom0 crashed and the server
> >>>>> rebooted. A lot of output was displayed on screen but quickly
> >>>>> vanished as the system rebooted. I'm trying to see if the output
> >>>>> was saved anywhere. Any ideas why this could of happened and/or
> where the output might be saved?
> >>>>>
> >>>>>
> >>>> I'd also like to add that after the server came back up, the md
> >>>> raid array started rebuilding. I wondering if that's just a
> >>>> coincidence (due to the forced reboot), or a sign of something
> >>>> wrong with the md integration with bcache?
> >>>>
> >>>> I'm going to see if Windows installs natively on the md array (it's
> >>>> RAID
> >>>> 10 btw) and post back here.
> >>>
> >>> Ok, so trying to install Windows directly onto the spindles causes
> >>> the same thing to happen. I'm going to try and boot up into the
> >>> non-bcache kernel (The default ubuntu one) and see if it works
> >>> there. If it fails there, then this is clearly a xen and/or mdraid issue...
> >>>
> >>> Thanks
> >>>
> >>>
> >> Ok, so booting into the default Ubuntu kernel, the windows
> >> installation seems to progress just fine.
> >>
> >> Does this mean there is something wrong with the mdraid code in the
> >> bcache kernel?
> >>
> >> Actually, I'm not telling the whole story. The kernel I'm using is
> >> the
> >> bcache-3.2 tree (from evilpriate.org) with changes merged in from
> >> kernel.org's 3.2.27 tree. There were no merge conflicts when I did
> >> the git merge.
> >>
> >> What do you think I should do?
> >>
> >>
> >> Thanks
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-bcache" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > I would recommend booting with the raw bcache-3.2 branch before
> > applying the stable patches (even though they should be fine) and
> > trying to catch the panic.
> > This is easiest done with a serial port and setting it to the kernel
> > console on the kernel command line in grub.
> >
> > Joseph.
> Hi There,
> 
> I can confirm that the problem occurs even when using the raw bcache-3.2
> branch from evilpirate.org. Just to clarify, I am trying to install Windows
> Server 2008 in a Xen HVM DomU, onto an LV which is on top of a MDRAID 10
> array. Using the bcache-3.2 kernel, the system reboots (after
> panicing) as soon as I click 'next' after selecting the drive to install windows
> onto. Using the standard Ubuntu kernel everything works as normal. This
> leads me to believe that there is an issue with the mdraid code inside the
> bcache-3.2 tree. I'd like to stress that I wasn't doing any bcaching during this
> test.
> 

FWIW, i'm using the 3.2 patches applied to a Debian kernel with lvm on raid1 (not raid10) on bcache and it's all working fine since I changed to a 512 byte block size. I haven't done an install of 2008, just 2003, but there doesn't seem to be any problems.

> What should my next step be? Try and find a serial cable to capture the
> debug output?
> 

Before tinkering with a serial cable, see if the system is alive enough to use netconsole - it can be a bit of a timesaver.

James

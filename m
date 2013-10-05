From: Ryan Press <ryan-KcFX5CmBy0dzbRFIqnYvSA@public.gmane.org>
Subject: Changing writeback_delay
Date: Sat, 5 Oct 2013 07:31:58 -0700
Message-ID: <CABx3TkXy0cAAXx+iFj8O11yD+jZGPh31rWqG-1f70ha+QhmCCg@mail.gmail.com>
References: <CABx3TkUS1TeBOzRY+E4TS7QsyORAaJNG6qy3FvEYQvHQ2+RbNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABx3TkUS1TeBOzRY+E4TS7QsyORAaJNG6qy3FvEYQvHQ2+RbNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

I'm running 3.11 kernel, and I've been playing around with bcache.
I'd like to set something up where I can spin down the hard disks to
save power, reading and writing to the SSD as much as possible.  It is
working quite well performance wise, with normal sequential speed as
well as greatly improved random access speeds.

To avoid spinning up the disk for writes, I have enabled writeback
mode.  I would like to increase writeback_delay, but whatever I set it
to has no effect.  If I spin down the hard disk with 'hdparm -Y
/dev/sda', touch a file on the mounted share, exactly 30 seconds after
I touch the file (the default writeback_delay) the hard drive spins
up, regardless of what I echo to writeback_delay, even though a cat of
writeback_delay shows it has changed.

Any ideas?  Do I need to set writeback_delay in some sequence for it
to take effect?

Thanks,
Ryan

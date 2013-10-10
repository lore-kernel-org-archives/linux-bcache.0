From: Ryan Press <ryan-KcFX5CmBy0dzbRFIqnYvSA@public.gmane.org>
Subject: Re: Changing writeback_delay
Date: Thu, 10 Oct 2013 10:50:31 -0700
Message-ID: <CABx3TkUh_VR9bg41GPFhxWisLBe8XsRTL-_CtxXCeYwPst239A@mail.gmail.com>
References: <CABx3TkUS1TeBOzRY+E4TS7QsyORAaJNG6qy3FvEYQvHQ2+RbNw@mail.gmail.com>
	<CABx3TkUVEAdbRYc3e6cU3URGOt7Ta_4HaCm37D1pd0qnpN78sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABx3TkUVEAdbRYc3e6cU3URGOt7Ta_4HaCm37D1pd0qnpN78sg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> On Fri, Oct 4, 2013 at 10:01 PM, Ryan Press <ryan-KcFX5CmBy0dzbRFIqnYvSA@public.gmane.org> wrote:
>
> I'm running 3.11 kernel, and I've been playing around with bcache.  I'd like to set something up where I can spin down the hard disks to save power, reading and writing to the SSD as much as possible.  It is working quite well performance wise, with normal sequential speed as well as greatly improved random access speeds.
>
> To avoid spinning up the disk for writes, I have enabled writeback mode.  I would like to increase writeback_delay, but whatever I set it to has no effect.  If I spin down the hard disk with 'hdparm -Y /dev/sda', touch a file on the mounted share, exactly 30 seconds after I touch the file (the default writeback_delay) the hard drive spins up, regardless of what I echo to writeback_delay.
>
> Any ideas?  Do I need to set writeback_delay in some sequence for it to take effect?


Alright, after some more testing it seems that writeback_delay is
indeed working as intended.  There is something else touching the
disk, and I'm pretty sure it's the btree stuff.  It has 30 seconds
hardcoded in two different places as so:

   if (btree_node_dirty(b))
      queue_delayed_work(btree_io_wq, &b->work,
         msecs_to_jiffies(30000));

...and...

   if (!btree_node_dirty(b))
      queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);

I guess this commits the btree to both the SSD and the hard disk?  Is
it possible to increase this delay without compromising integrity (say
for a power failure) or is this a major design change?

Thanks,
Ryan

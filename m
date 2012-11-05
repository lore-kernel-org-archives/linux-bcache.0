From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: Re: Kernel Oops (bCache hangs on registering 3rd device)
Date: Mon, 5 Nov 2012 13:01:18 +0000 (UTC)
Message-ID: <loom.20121105T135531-268@post.gmane.org>
References: <loom.20121104T035737-445@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

James Sefton <james@...> writes:

> 
> Hi,
> 
> Seems I broke something.
> 
> I have run into this problem about 3 times now where bCache (or something!) 
> seems to hang and I only just thought to check kern.log before trying to 
reboot 
> so was previously assuming something else had just got stuck!
> 
> I only had 3 servers available to me and once this problem occurs, the servers 
> seems to get stuck rebooting so I cannot do another test to confirm tonight.  
(I 
> have put a reboot request in for them to be force rebooted but that will not 
get 
> actioned until tomorrow)
> 
> Here is what I know about the most recent time this happened:
> 
> I had already set-up and been using /dev/bcache0 and /dev/bcache1.  They are 
> attached to the cache set and set to writeback.
> 
> The problem occurred when I ran "echo /dev/rbd2 >/sys/fs/bcache/register".   
> This device had been newly formatted with "make-bcache -B /dev/rbd2"   (rbd2 
is 
> a SAN based block device)
> 
> If it makes any difference - these commands are in a script so the register 
> command would have been run *immediately* after the make-bcache command 
> returned.  (I am going to try sticking a sleep 3 or something in there 
tomorrow 
> - just in case its related to trying to register the device so quickly after 
it 
> was prepared)
> 
> At this point my console just stops.  I cannot CTRL+C to abort the echo 
command.
> top shows increasing load average - presumably it thinks a process is stuck 
> waiting for something.  Rebooting server kicks me out of console and then 
never 
> comes back.
> 
> /dev/rbd0 and /dev/rbd1 are already registered at this point and were working 
> fine.  If I open another console (did this before rebooting) and create 
> /dev/rbd3, and then try and register it - the same happens again.
> 
> Here is what came up in kern.log:
> 
> http://pastebin.com/xNBuv3sj
> (Using Gmane to post and it complained about long lines)
> 
> Any ideas?
> 
> Cheers,
> 
> James
> 
> 


Yes, reproduced it after a clean boot.
It gets stuck creating the third cache device. (/dev/bcache2)

Here is the latest info from kern.log, but it looks very similar to what I 
posted before.

http://pastebin.com/r8YRSNGR

Any idea if I am doing something wrong or is this a bug?
I need to create up to 64 cache devices.  Possibly slightly over that on rare 
occasions.  (The majority of servers will have 16-32)

Many Thanks,

James

From: "Vladimir Elisseev" <vovan-Ev2gRJHyJ8g@public.gmane.org>
Subject: 3.10.x - issues with nvidia proprietary drivers
Date: Wed, 07 Aug 2013 11:34:32 +0200
Message-ID: <524d-52021480-5-10075740@166352631>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

I'm using bcache for a few weeks at the moment (started with kernel 3.10) and it works perfectly fine unless I use nvidia proprietary driver (tried 325.08 and 325.15). When nvidia kernel module is not blacklisted system can't be booted properly with X server: display hangs while loading display manager, but system is accessible via ssh and there's no error messages in the log files. The strange thing is that I can boot and start display manager if nvidia module is blacklisted and later loaded by xorg server. With this workaround I can login and everything works just as expected. However, when I try to logout the display goes black (keyboard doesn't works except SysRq keys), but system is accessible via ssh or somehow else. While system hangs in the way described above I can see following s
 uspicious things:
- the X server process is waiting for disk (status Ds+)
- it's not possible to kill the X server process (using any signal)

I'd appreciate if somebody would give any hits on how can I investigate this problem any further.

Thanks in advance,
Vlad.
 

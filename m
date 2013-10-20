From: =?UTF-8?B?UGF2ZWwgUGFsw6F0?= <pavel.palat-UDV0GzaorVTrBKCeMvbIDA@public.gmane.org>
Subject: bcache writeback hang with 3.11.5 and 3.10.17
Date: Sun, 20 Oct 2013 15:42:33 +0200
Message-ID: <5263DDC9.6050705@devsoft.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

I have experienced hangs with above kernel and bcache in writeback mode. 
Hangs are very easily archieved - just do:

mkdir /data/tmp
cp -xar / /data/tmp

Cancel after 1-5 minutes, then do sync (sometimes don't needed) and it 
hangs. Either the sync hangs and/or the cp (or rm /data/tmp). Behaviour 
is very consistent, it happens every time I enable writeback and perform 
IO heavy operations.

I have not experienced the issue so far with writethrough mode.

Hardware is HP j000ec, attaching dmesg from hanged box with both 3.11.5 
and 3.10.17 LTS kernel. Distribution is arch linux.

dmesg outputs is available on 
http://www.devsoft.cz/upload/bcache_bugreport.tar.gz

P.

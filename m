From: Ross Anderson <rosander-Ffui8Hzh9qpeoWH0uzbU5w@public.gmane.org>
Subject: Bcache hang
Date: Wed, 09 Jan 2013 13:17:39 -0600
Message-ID: <50EDC253.1020609@dsotm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Current bcache and bcache-testing cause kernel panic on bcache add. 
These are on existing devices, Echo 1 to unregistered, remove existing 
cache device replace with new, make-bcache -C, then echo to register. 
Register hangs and following kernel output and hang occurs.



The following is debug info for the hang
http://pastebin.com/87iYygdw

From: Brad Campbell <lists2009-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: "Benchmarks"
Date: Sat, 22 Oct 2011 08:29:02 +0800
Message-ID: <4EA20E4E.8050402@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I use the term loosely.

This is with the raw drive being a Maxtor MaxlineII 250GB 7200RPM SATA 
unit. It's about a 2004 vintage with over 30,000 hours on it. Slow and 
steady.

The Cache device is an OCZ Vertex Plus 120GB Unit. Not all that fast or 
clever. The Cache has writeback enabled and is formatted with -w512 so 
that direct IO worked as previously discussed.

The benchmark is conducted inside an XP VM running under KVM. The device 
is a qcow2 backing file formatted NTFS. I ran the test multiple times 
without the cache until the numbers stabilised (the backing file was 
being expanded as required)

http://www.fnarfbargle.com/private/111022_bcache/Without_Cache.png
http://www.fnarfbargle.com/private/111022_bcache/With_Cache.png

As expected a significant improvement in random small I/O. The VM is far 
more responsive with the cache.

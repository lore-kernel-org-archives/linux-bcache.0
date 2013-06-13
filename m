From: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>
Subject: (b)cache trashing
Date: Thu, 13 Jun 2013 22:33:49 +0200
Message-ID: <20130613203348.GA3019@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi all,

one (or two), naive, question.

I assume that bcache will cache on reads too.

What will happen if something like this is run:

find /home -type -f -exec md5sum {} \;

That is, the md5 of *all* files is computed.

I assume that the cache will be completely
trashed and no old data will be present.

Is this the case?

Now, assuming we have a RAID something, with
LVM on top, with different volumes.
For example one for /home, one for /usr, etc.
Would it make sense, in respect of the above
trashing, to have different SSD (or paritions)
to cache the different volumes?
Instead of caching the complete RAID, of course.

Thanks a lot in advance,

bye,

-- 

piergiorgio

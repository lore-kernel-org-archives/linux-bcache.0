From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Bcache in Xen Environment
Date: Wed, 01 Aug 2012 10:20:15 +0100
Message-ID: <5fe181f7719e9d85f15e0906688388bd@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Everyone,

I wish to investigate using bcache in a Xen virtualisation environment. 
We wish to use bcache to add a SSD (single drive) cache to a RAID10 
device (using metal spindles), and I have a few questions.

1) On the bcache website, it says this:

"It won't return a write as completed until everything necessary to 
locate it is on stable storage, nor will writes ever be seen as 
partially completed (or worse, missing) in the event of power failure."

Is this just true for write-through? Or write-back mode as well? If it 
is true for write-back mode, how does this work? I thought the point of 
write-back mode was to return write quickly due to the fast buffer 
storage.

2) When we delete a virtual machine, it is common for us to run dd to 
"zero" the LVM LV so that data is deleted. If we introduce bcache, can 
we still be sure that all data is gone? We need to make sure that no 
data leakage can occur between LVs.

3) SSD storage has a much more limited write span that metal spindles. 
If an SSD drive were to fail, will the RAID10 spindle array still 
continue to function? Will any data be lost? How does write-through and 
write-back handle these cases?

Thanks for your time.

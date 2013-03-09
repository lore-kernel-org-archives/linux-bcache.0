From: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Bcache data layout - suited as swap filesystem on SSDs?
Date: Fri, 08 Mar 2013 22:52:02 -0800
Message-ID: <khem6g$avh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I came across a paper [1] today talking about improving the Linux swap 
system for use on SSDs, and I realized that some points made in the paper 
could be addressed by using bcache 'in reverse', where instead of caching a 
slower block device it stores pages on behalf of faster memory.

Bcache already optimizes for SSDs by writing linearly where possible, using 
'buckets' sized to work well with eraseblocks, and taking advantage of high 
random read performance.

The paper advocates doing much the same with swap on SSDs, although it also 
talks about removing layers of software between the VM and the SSD.

Since bcache is an efficient way of storing sparse, fixed-size chunks of 
data identified by addresses, it might be a really interesting data layout 
for efficient swap on SSDs.

[1] http://pages.cs.wisc.edu/~msaxena/FlashVMpaper.html

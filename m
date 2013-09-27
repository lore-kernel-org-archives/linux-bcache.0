From: Hans Kraus <hans-V6XWkrn/fmtByuSxxbvQtw@public.gmane.org>
Subject: Partition possible as caching device; external journal for Ext4?
Date: Fri, 27 Sep 2013 10:21:26 +0200
Message-ID: <52454006.7020902@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

is it possible to use only a partition of an SSD as caching device for
bcache or is a complete device necessary?

Is there a rule of thumb for the cache size? Eg. at what value I do get
diminishing returns?

When I cache a big Raid6 with Ext4, makes it still sense (performance
wise) to put the journal on a separate SSD partition?

Regards, Hans

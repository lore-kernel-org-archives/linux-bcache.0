From: Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>
Subject: Inconsistent Performance
Date: Mon, 29 Jul 2013 15:32:49 +1200
Message-ID: <51F5E261.6050600@networklabs.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

We are noticing some odd performance characteristics with bcache on 3.10 
Mainline kernel.

We are using Intel DC S3700 SSD and Seagate Constellation ES.2 HDD

Using FIO to perform a 4K random write test with QD=32 and 4 instances 
we get:

RAW SSD:    55.5K iops

RAW HDD:   540 iops

Fresh bcache on top of SSD/HDD [writeback]:    36.8K iops

Which is not great, but OK.

However if I run the FIO test a number of times, letting it write out 
the data to the backing device after each run, after a few runs I will 
notice the IOPS drop.  When the benchmark starts it will sit around 14K 
IOPS, then as soon as it starts writing to the backing device this will 
drop to around 5K IOPS. On the subsequent runs it will never go above 5K 
IOPS.



Has there been a performance regression on 3.10 ?



Regards,





Andrew

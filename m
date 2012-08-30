From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Expected Behavior
Date: Thu, 30 Aug 2012 08:15:58 +0100
Message-ID: <503F132E.6060305@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi There,

On my WIndows DomU (Xen VM) which is running on a LV which is using 
bcache (against two SSD in MDRAID1 and a MD-RAID10 spindle array), I ran 
an IOMeter test for about 2 hours (with 30 workers and a io depth of 
256). This was a very heavy workload (Got an average iops of about 
6.5k). After I stopped the test, I then went back to fio on my Linux Xen 
Host (Dom0). The random write performance isn't as good as it was before 
I started the IOMeter test. It used to be about 25k and now showed about 
7k iops. I assumed that maybe this was due to the fact that bcache was 
writing out dirty data to the spindles so the SSD was busy.

However, this morning, after the spindles have calmed down, performance 
of fio is still not great (still about 7k).

Is there something wrong here? What is expected behavior?

Thanks

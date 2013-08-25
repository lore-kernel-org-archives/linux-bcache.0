From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: [RFC] bcache-status
Date: Sun, 25 Aug 2013 22:39:46 +0200
Message-ID: <521A6B92.60001@rolffokkens.nl>
References: <521A55D4.20908@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521A55D4.20908-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I took the liberty of adding bcache-status to the bcache-tools package 
I'm building:

https://bugzilla.redhat.com/show_bug.cgi?id=999690#c12

I have a few questions/remarks:
- Is the python3 dependency really needed? I changed it to ordinary 
python(2) and it runs fine I think.
- Is https://gist.github.com/damoxc/6267899 the proper source?
- When the bcache kernel module is not loaded, the feedback looks buggy:
[root@home07 ~]# bcache-status
Traceback (most recent call last):
   File "/sbin/bcache-status", line 348, in <module>
     main()
   File "/sbin/bcache-status", line 333, in main
     for cache in os.listdir(SYSFS_BCACHE_PATH):
OSError: [Errno 2] No such file or directory: '/sys/fs/bcache/'
[root@home07 ~]#

Rolf

On 08/25/2013 09:07 PM, Rolf Fokkens wrote:
> To allow Fedora users to benefit from bcache I'm currently packaging 
> bcache-tools for Fedora.
>
> See also: https://bugzilla.redhat.com/show_bug.cgi?id=999690

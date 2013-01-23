From: Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>
Subject: Registering bcache devices
Date: Wed, 23 Jan 2013 13:51:56 +1300
Message-ID: <50FF342C.60605@networklabs.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I am attempting to get bcache devices to register by echoing all 
/dev/sd* and /dev/dm-* to the bcache registration in /sys but get the 
following:

echo /dev/dm-* > /sys/fs/bcache/register
bash: echo: write error: Invalid argument

echo /dev/sd* > /sys/fs/bcache/register
bash: echo: write error: Invalid argument


I am using a 3.7 kernel pulled from 4747cd9 revision.

Is this a bug, or am I just "doing it wrong" ?


Regards,





Andrew Thrift

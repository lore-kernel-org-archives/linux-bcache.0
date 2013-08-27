From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-tools: minor change for bcache-register
Date: Tue, 27 Aug 2013 08:58:51 +0200
Message-ID: <521C4E2B.8090008@rolffokkens.nl>
References: <521B1C5E.2090007@rolffokkens.nl> <20130826214155.GA2798@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130826214155.GA2798@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Would you consider another change as well:

--- bcache-tools-20130827.orig/bcache-register    2013-08-26 
23:46:19.000000000 +0200
+++ bcache-tools-20130827/bcache-register    2013-08-27 
08:55:48.060477014 +0200
@@ -1,4 +1,4 @@
  #!/bin/sh
-modprobe -qba bcache
+/sbin/modprobe -qba bcache
  test -f /sys/fs/bcache/register_quiet && echo "$1" > 
/sys/fs/bcache/register_quiet

/sbin is not in the $PATH for utilities started from udev. For Fedora it 
isn't anyway, but it won't harm other distro's neither.

On 08/26/2013 11:41 PM, Kent Overstreet wrote:
> On Mon, Aug 26, 2013 at 11:14:06AM +0200, Rolf Fokkens wrote:
>> Hi!
>>
>> bcache-register is called from the provided udev rules in
>> bcache-tools. During boot it seams like some devices are registered
>> multiple times, which results in messages during boot. To suppress
>> these messages I redirect them to /dev/null in the following patch:
>>
>> --- bcache-tools-20130820/bcache-register.register      2013-08-20
>> 22:03:46.000000000 +0200
>> +++ bcache-tools-20130820/bcache-register       2013-08-25
>> 21:31:11.707823194 +0200
>> @@ -1,4 +1,9 @@
>>   #!/bin/sh
>> -modprobe -qba bcache
>> -test -f /sys/fs/bcache/register && echo "$1" > /sys/fs/bcache/register
>> +#
>> +# Utility script to be called from udev, so it's not monkey proof
>> at all. It's
>> +# sole purpose is to load the bcache kernel module whenever a
>> bcache device is
>> +# detected.
>> +#
>> +/usr/sbin/modprobe -qba bcache
>> +test -f /sys/fs/bcache/register && echo "$1" >
>> /sys/fs/bcache/register 2>/dev/null
>>
>> I can imagine there's a more elegant solution, suggestions are welcome.
> Just use /sys/fs/bcache/register_quiet instead of register.
>
> I'll change it to do that.

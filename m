From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: RE: Expected Behavior
Date: Fri, 31 Aug 2012 13:36:24 +0100
Message-ID: <a7955ba43dfd9792245545eeb8c54e55@abpni.co.uk>
References: <503F132E.6060305@abpni.co.uk> <503F147A.10101@abpni.co.uk>
 <239802233aa1dabc37f60b293d2941c9@abpni.co.uk>
 <20120830212841.GB14247@google.com> <503FF05B.1040506@abpni.co.uk>
 <6035A0D088A63A46850C3988ED045A4B29A7D49D@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B29A7D49D-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org



On 31.08.2012 04:47, James Harper wrote:
>> Hi Kent,
>>
>> I'm going to try and reproduce it myself as well. I just used 
>> IOMeter in a
>> Windows DomU with 30 workers, each having an io depth of 256. A 
>> *very*
>> heavy workload indeed, but my point was to see if I could break 
>> something.
>> Unless the issue is specific to windows causing problems (NTFS or 
>> whatever),
>> I'm guessing running fio with 30 jobs and an iodepth of 256 would 
>> probably
>> produce a similar load.
>>
>> BTW, do you have access to a Xen node for testing?
>>
>
> Does the problem resolve itself after you shut down the windows DomU?
> Or only when you reboot the whole Dom0?
>

Hi There,

I managed to reproduce this again. I have to reboot the entire Dom0 
(the physical server) for it to work properly again.

James, are you able to reproduce this? Kent, are there any other 
tests/debug output you need from me?

Thanks

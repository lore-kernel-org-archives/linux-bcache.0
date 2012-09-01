From: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Subject: Re: Expected Behavior
Date: Sat, 01 Sep 2012 13:47:52 +0100
Message-ID: <504203F8.4000302@abpni.co.uk>
References: <503F132E.6060305@abpni.co.uk> <503F147A.10101@abpni.co.uk> <239802233aa1dabc37f60b293d2941c9@abpni.co.uk> <20120830212841.GB14247@google.com> <503FF05B.1040506@abpni.co.uk> <6035A0D088A63A46850C3988ED045A4B29A7D49D@BITCOM1.int.sbss.com.au> <a7955ba43dfd9792245545eeb8c54e55@abpni.co.uk> <151f74230aeb6825d9b8b633881d5e6c@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <151f74230aeb6825d9b8b633881d5e6c-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>
Cc: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 31/08/2012 13:41, Jonathan Tripathy wrote:
>
>
> On 31.08.2012 13:36, Jonathan Tripathy wrote:
>> On 31.08.2012 04:47, James Harper wrote:
>>>> Hi Kent,
>>>>
>>>> I'm going to try and reproduce it myself as well. I just used 
>>>> IOMeter in a
>>>> Windows DomU with 30 workers, each having an io depth of 256. A *very*
>>>> heavy workload indeed, but my point was to see if I could break 
>>>> something.
>>>> Unless the issue is specific to windows causing problems (NTFS or 
>>>> whatever),
>>>> I'm guessing running fio with 30 jobs and an iodepth of 256 would 
>>>> probably
>>>> produce a similar load.
>>>>
>>>> BTW, do you have access to a Xen node for testing?
>>>>
>>>
>>> Does the problem resolve itself after you shut down the windows DomU?
>>> Or only when you reboot the whole Dom0?
>>>
>>
>> Hi There,
>>
>> I managed to reproduce this again. I have to reboot the entire Dom0
>> (the physical server) for it to work properly again.
>>
>> James, are you able to reproduce this? Kent, are there any other
>> tests/debug output you need from me?
>>
>
> BTW, I was using IOMeter's 'default' Access Specification with the 
> following modifications: 100% random, 66% read, 33% write, and a 2kB 
> size. My bcache is formatted for 512bytes.
> -- 
>
Kent, is there any debug output of some sort I could switch on and help 
you figure out what's going on? If needs be, I can give you access to my 
setup here where you can run these tests yourself, if you're not keen 
installing Xen on your end :)

Thanks

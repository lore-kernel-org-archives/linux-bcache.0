From: Nick Payne <nick.payne-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>
Subject: Re: Can't enable writeback
Date: Sun, 18 Aug 2013 07:39:05 +1000
Message-ID: <520FED79.4070306@internode.on.net>
References: <520F65C8.8050301@internode.on.net> <kunruq$541$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <kunruq$541$1@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 17/08/13 22:56, Gabriel de Perthuis wrote:
>> I try to enable writeback:
>>
>>     sudo echo writeback > /sys/block/bcache0/cache_mode
>>
>> it returns the error
>>
>>     bash: /sys/block/bcache0/cache_mode: No such file or directory
> You're confusing bcache0 with bcache0/bcache
>
>      echo writeback |sudo tee -a /sys/block/bcache0/bcache/cache_mode
>
> will work.

Thanks, that works. The command I was originally trying to use is what 
is shown in the documentation at 
http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt. 
It has

     # echo writeback > /sys/block/bcache0/cache_mode

as the command to run.

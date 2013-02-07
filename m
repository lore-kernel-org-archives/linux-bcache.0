From: Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>
Subject: Re: bcache vs enhanceio?
Date: Fri, 08 Feb 2013 12:05:49 +1300
Message-ID: <5114334D.7040709@networklabs.co.nz>
References: <14121605.34.1360272310720.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <14121605.34.1360272310720.JavaMail.root@zimbra>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Roy,

This is by design, and minimizes the potential for data corruption.

If you have a backing device with an existing filesystem, and are 
caching this in writeback mode, then reboot the system and the cache 
device does not come up, the backing device could still come up and 
could potentially be out of sync with the writes that were buffered to 
the cache device.

With bcache in writeback mode, if it cannot attach the cache device it 
will not register the backing device.


I am sure Kent will provide a much better answer than I have  :)




Regards,




Andrew

On 2/8/2013 10:25 AM, Roy Sigurd Karlsbakk wrote:
> Hi
>
> Seems old flashcache and the new enhanceio can add flash drives on the run, while bcache needs the filsystem to be built with them.
>
> What is the future of bcache in this setting?
>

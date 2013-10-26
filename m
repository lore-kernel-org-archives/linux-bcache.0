From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache-tools and bcache support in other linux packages
Date: Sat, 26 Oct 2013 17:06:39 +0200
Message-ID: <526BDA7F.5060302@rolffokkens.nl>
References: <20131020185937.GA18759@lazy.lzy> <CE8AE869.BD62%rolf@rolffokkens.nl> <20131021164756.GA8027@lazy.lzy> <5266BBA7.4070106@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5266BBA7.4070106-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-i47jiTeKxPI@public.gmane.org>
Cc: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Development discussions related to Fedora <devel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 10/22/2013 07:53 PM, Rolf Fokkens wrote:
> Well, I agree, there's more to it. Like cost. One could consider to 
> pair serveral HHD' each with a dedicated bcache SSD. And from that one 
> could build a RAID array. This RAID array has excellent (read) 
> performance because of the combined SSD performance. This storage 
> system does break when one of the HDD's or SDD's breaks, which is also 
> a nice feature. So if it weren't for the cost (and the number of 
> availbale SATA connectors) this could be interresting. But it's all a 
> matter of requirements of course.
I noticed a somewhat confusing typo, the right sentence is "This storage 
system does NOT break when one of the HDD's or SDD's breaks".

From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: speed up dirty data cleaning
Date: Thu, 07 Nov 2013 16:18:35 +0100
Message-ID: <527BAF4B.9080609@profihost.ag>
References: <527B90EF.10404@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527B90EF.10404-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

After some time it seems to start writing out all the data at a good
disk speed.

But how does bcache determine when to write which kind of data out of
bcache.

Stefan

Am 07.11.2013 14:09, schrieb Stefan Priebe - Profihost AG:
> Hi,
> 
> today i had the problem that my caching device was nearly full and
> bcache seemed tom react very slowly. Strangely i did not see continues
> writes to the disk to clean the cache.
> 
> Is there any way to speed up dirty data cleaning.
> 
> Stefan
> 

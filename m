From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Error "unsupported bset version"
Date: Mon, 26 Aug 2013 15:10:09 -0700
Message-ID: <20130826221009.GH2798@kmo-pixel>
References: <52189D62.7010603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52189D62.7010603-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tobias Reinhard <trtracer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sat, Aug 24, 2013 at 01:47:46PM +0200, Tobias Reinhard wrote:
> Hi all,
> 
> I'm running bcache to speed up my 4 TB HDD with a 64 GB partition on
> my SSD. After a reboot bcache didn't start automatically. So I
> stopped bcache, unloaded the module, reloaded it and tried to
> register the SSD and HDD again.
> 
> Registering the SSD gave me this error:
> error on f1e69e99-940d-447a-900e-4956bd607933: unsupported bset
> version at bucket 108098, block 0, 855650560 keys, disabling caching
> 
> The bcache was running in writeback mode but I think it was almost
> clean so I forced the device to go online and made an fsck.
> Everything looks ok, so no data loss. But surely this should not
> happen, right? Is there any way to check why? (I made an image of
> the cache device)

I think this was the result of a bug for which I accidentally didn't
mark the fix for stable - the fix was in 3.11

I just sent out a pull request to get it into 3.10, and in the meantime
I have a branch with all the relevant fixes on top of 3.10:

git://evilpiepirate.org/~kent/linux-bcache.git bcache-3.10-stable

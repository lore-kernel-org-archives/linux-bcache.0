From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Registering bcache devices
Date: Tue, 22 Jan 2013 16:54:33 -0800
Message-ID: <20130123005433.GG26407@google.com>
References: <50FF342C.60605@networklabs.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50FF342C.60605-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 23, 2013 at 01:51:56PM +1300, Andrew Thrift wrote:
> Hi,
> 
> I am attempting to get bcache devices to register by echoing all
> /dev/sd* and /dev/dm-* to the bcache registration in /sys but get
> the following:
> 
> echo /dev/dm-* > /sys/fs/bcache/register
> bash: echo: write error: Invalid argument
> 
> echo /dev/sd* > /sys/fs/bcache/register
> bash: echo: write error: Invalid argument
> 
> 
> I am using a 3.7 kernel pulled from 4747cd9 revision.
> 
> Is this a bug, or am I just "doing it wrong" ?

You've got to echo them one at a time, like so:

for i in `ls /dev/sd*`; do
	echo    $i > /sys/fs/bcache/register_quiet
done

(initramfs/script in bcache-tools does this)

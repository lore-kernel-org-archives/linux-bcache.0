From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: RE: hang
Date: Mon, 3 Sep 2012 09:33:19 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B29A822AA@BITCOM1.int.sbss.com.au>
References: <6035A0D088A63A46850C3988ED045A4B29A7F38D@BITCOM1.int.sbss.com.au>
 <20120903004113.GB20060@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120903004113.GB20060-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> Hmm.
> 
> If it's related to lvm snapshots, there's a workaround I just added to the
> bcache-3.2 branch - I'd give that a try, looks plausible from your log.
> 

Is that the default writeback_percent = 10 in commit 113740372e2244951fb34235b30a2ac646a5d8c2?

Can I effect the same change by "echo 10 >writeback_percent"? If so then it would save the hassle of a rebuild just to test. I assume it's sleep time in your timezone at the moment so I'll test it anyway and let you know - it was failing pretty consistently, within 30 seconds of starting my restore job.

James

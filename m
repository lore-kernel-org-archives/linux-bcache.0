From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] bcache-status
Date: Mon, 9 Sep 2013 15:45:32 -0700
Message-ID: <20130909224532.GB4553@blackbox.djwong.org>
References: <521A55D4.20908@rolffokkens.nl>
 <521A6B92.60001@rolffokkens.nl>
 <20130826163055.GB4780@blackbox.djwong.org>
 <521BBC3B.9010003@rolffokkens.nl>
 <20130829004646.GA3099@blackbox.djwong.org>
 <52264AAD.3050401@rolffokkens.nl>
 <20130904202600.GA4554@blackbox.djwong.org>
 <52279DA5.7050505@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52279DA5.7050505-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Sep 04, 2013 at 10:52:53PM +0200, Rolf Fokkens wrote:
> I'm not sure if I understand.
> 
> On 09/04/2013 10:26 PM, Darrick J. Wong wrote:
> >Yeah... I calculate total cache size, then cache-used = cache-size * whatever
> >percentage bcache reports.  It won't add up exactly due to rounding errors.
> >0.999 -> 1.00.  That's rather a lot, really.
> Is the following (snippet of the output I sent) the result of
> rounding errors?
> 
> Total Cache Size            1.00GiB
> Total Cache Used            204.00MiB    (10%)
> Total Cache Unused          1.00GiB    (90%)
> 
> I mean: the percentages are 10% and 90%..

Oops, this was a Py3 v. Py2 issue -- Python3 saw the '%.2f' in the function
that pretty-printed cache sizes and would fp-divide the two integers, whereas
Pyhon2 saw that we were trying to divide two integers and used integer
division. Fixed in the Gist.

Kent: Any chance you'd like to pick up bcache-status into bcache-tools.git?

(Or really, anyone who has commit access to that repo.)

--D
> 
> >>- "Dirty Data" is -6 MB?
> >I think this was fixed in 3.11.
> OK, so that is a kernel issue.

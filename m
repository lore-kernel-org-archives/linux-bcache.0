From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: Git repositories
Date: Tue, 27 Jan 2015 14:01:46 -0800
Message-ID: <20150127220146.GA21432@daterainc.com>
References: <baa05f9cf5caef3dd4101b22d13fcbae@de.mcbf.net>
 <CALJ65z=vLyth5gPcD2NJ0QS+HGoeFLg8XPY4VKDGQMUVJw2mOg@mail.gmail.com>
 <54C6CD1E.7020106@rolffokkens.nl>
 <CALJ65zmRACiT1p4eJxfNOvK8iZvkPuRP+80TnfVrseMdN2wbzg@mail.gmail.com>
 <95adb838f3b8fa76775857cb4268a105@de.mcbf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50237 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbbA0WBt (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 27 Jan 2015 17:01:49 -0500
Received: by mail-pd0-f171.google.com with SMTP id fp1so21366826pdb.2
        for <linux-bcache@vger.kernel.org>; Tue, 27 Jan 2015 14:01:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <95adb838f3b8fa76775857cb4268a105@de.mcbf.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: David Mohr <damailings@mcbf.net>
Cc: Rolf Fokkens <rolf@rolffokkens.nl>, linux-bcache@vger.kernel.org, robie.basak@ubuntu.com, g2p.code@gmail.com

On Tue, Jan 27, 2015 at 12:00:31AM -0700, David Mohr wrote:
> On 2015-01-26 16:37, Kent Overstreet wrote:
> >Ok, I just merged from him and pushed.
> 
> Great, thanks for getting that worked out so quickly!
> 
> The merge doesn't import the tags though. I think it make sense to set those
> in the evilpiepierate's repository as well:

Ok, tags are pushed too now.

> >On Mon, Jan 26, 2015 at 3:26 PM, Rolf Fokkens <rolf@rolffokkens.nl> wrote:
> >>Well, to be honest I built the latest Fedora bcache-tools packages based
> >>on
> >>https://github.com/g2p/bcache-tools. So I'm perfectly happy with what's
> >>in
> >>it. If all of g2p's repo is merged into
> >>http://evilpiepirate.org/git/bcache-tools.git/ I'll use that one as my
> >>source repo again.
> 
> Thanks for the quick feedback. FWIW, the debian packaging was also built
> upon g2p's repository. But now that there's the active bcache-dev branch on
> the evilpiepirate repository, and the website always refered to that
> repository as well, it was confusing. It seems better to coordinate in one
> central place. We will from now on use evilpiepirate's repository as
> upstream for the Debian packages.

I'm still probably going to be fairly absent for the next couple months
unfortunately - if you guys are happy with what Gabriel is doing I'm fine with
him continuing to maintain bcache tools.

I can give him or someone access to push to my bcache-tools repository so you
guys aren't blocked if I'm off somewhere ignoring email :)

> >>So far I've been collaborating with Gabriel (g2p) using his Github repo
> >>as
> >>the starting point, assuming that's the one that will be pushed to
> >>evilpieprate in the end. At the moment though there are 3 pull requests
> >>pending (one of me) that don't get g2p's attention, I guess he's busy
> >>with
> >>other things. So I'll post my latest pull request here on the mailing
> >>list,
> >>so it can be discussed and Kent can decide if he wants to merge it.
> 
> I'm assuming Gabriel is on the ML? I'd say he should have a chance to merge
> the remaining pull requests - if he doesn't, or says that he doesn't want
> to, then I will post them here on the ML manually for consideration. The
> Debian packages don't currently use any patches.

I would like to see the pull requests (and patches too, ideally) posted on the
mailing list too - just with git send-email. Pull requests are fine, it's just
nice see the patch on the list too.

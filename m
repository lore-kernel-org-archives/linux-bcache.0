From: David Mohr <damailings@mcbf.net>
Subject: Re: Git repositories
Date: Tue, 27 Jan 2015 00:00:31 -0700
Message-ID: <95adb838f3b8fa76775857cb4268a105@de.mcbf.net>
References: <baa05f9cf5caef3dd4101b22d13fcbae@de.mcbf.net>
 <CALJ65z=vLyth5gPcD2NJ0QS+HGoeFLg8XPY4VKDGQMUVJw2mOg@mail.gmail.com>
 <54C6CD1E.7020106@rolffokkens.nl>
 <CALJ65zmRACiT1p4eJxfNOvK8iZvkPuRP+80TnfVrseMdN2wbzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from seeker.mcbf.net ([109.239.49.157]:49637 "EHLO seeker.mcbf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbbA0HAg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 27 Jan 2015 02:00:36 -0500
In-Reply-To: <CALJ65zmRACiT1p4eJxfNOvK8iZvkPuRP+80TnfVrseMdN2wbzg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: Rolf Fokkens <rolf@rolffokkens.nl>, linux-bcache@vger.kernel.org, robie.basak@ubuntu.com

On 2015-01-26 16:37, Kent Overstreet wrote:
> Ok, I just merged from him and pushed.

Great, thanks for getting that worked out so quickly!

The merge doesn't import the tags though. I think it make sense to set 
those in the evilpiepierate's repository as well:

g2p$ git show-ref --tags -d
8b3e39e0525df37dfbc840e49f2f5a4069b34a1f refs/tags/v1.0.1
0c7a484a5b09d710814451c06ad30e894deb7ff5 refs/tags/v1.0.2
4ff504e17b032b75f6d5546ec190c834ac69af8c refs/tags/v1.0.3
15f17ed3e9a8dbe44a0e60cd981f70b7a61d6f7a refs/tags/v1.0.4
ba2c1352365122b3b730de960896bd89020f6c06 refs/tags/v1.0.5
0aeb7a0a38c26d2da09c364148b037de7deeb7e5 refs/tags/v1.0.6
25016feee1aab63c4cdc1188bae40e481d6b17c1 refs/tags/v1.0.7
a73679b22c333763597d39c72112ef5a53f55419 refs/tags/v1.0.8

> On Mon, Jan 26, 2015 at 3:26 PM, Rolf Fokkens <rolf@rolffokkens.nl> 
> wrote:
>> Well, to be honest I built the latest Fedora bcache-tools packages 
>> based on
>> https://github.com/g2p/bcache-tools. So I'm perfectly happy with 
>> what's in
>> it. If all of g2p's repo is merged into
>> http://evilpiepirate.org/git/bcache-tools.git/ I'll use that one as my
>> source repo again.

Thanks for the quick feedback. FWIW, the debian packaging was also built 
upon g2p's repository. But now that there's the active bcache-dev branch 
on the evilpiepirate repository, and the website always refered to that 
repository as well, it was confusing. It seems better to coordinate in 
one central place. We will from now on use evilpiepirate's repository as 
upstream for the Debian packages.

>> So far I've been collaborating with Gabriel (g2p) using his Github 
>> repo as
>> the starting point, assuming that's the one that will be pushed to
>> evilpieprate in the end. At the moment though there are 3 pull 
>> requests
>> pending (one of me) that don't get g2p's attention, I guess he's busy 
>> with
>> other things. So I'll post my latest pull request here on the mailing 
>> list,
>> so it can be discussed and Kent can decide if he wants to merge it.

I'm assuming Gabriel is on the ML? I'd say he should have a chance to 
merge the remaining pull requests - if he doesn't, or says that he 
doesn't want to, then I will post them here on the ML manually for 
consideration. The Debian packages don't currently use any patches.

~David

>> On 01/26/2015 10:45 PM, Kent Overstreet wrote:
>>> 
>>> Yeah - but do you suppose you could coordinate with the Fedora 
>>> package
>>> maintainer, Rolf Fokkens - and make sure pulling that stuff works for
>>> him? Or if you guys have different patches, just let me know where I
>>> can pull them from.
>>> 
>>> On Mon, Jan 26, 2015 at 1:24 PM, David Mohr <damailings@mcbf.net> 
>>> wrote:
>>>> 
>>>> Hi,
>>>> 
>>>> in discussions around the Debian packaging the question came up why
>>>>    http://evilpiepirate.org/git/bcache-tools.git/
>>>> is the official repository when it seems like the current stable
>>>> development
>>>> takes place in
>>>>    https://github.com/g2p/bcache-tools
>>>> 
>>>> Would it be possible to merge Gabriel's work back into the main
>>>> repository
>>>> so that we can refer to evilpiepirate.org as the definitive 
>>>> upstream? If
>>>> not, what's the relationship between the repositories?
>>>> 
>>>> Thanks,
>>>> ~David

From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: Git repositories
Date: Mon, 26 Jan 2015 15:37:33 -0800
Message-ID: <CALJ65zmRACiT1p4eJxfNOvK8iZvkPuRP+80TnfVrseMdN2wbzg@mail.gmail.com>
References: <baa05f9cf5caef3dd4101b22d13fcbae@de.mcbf.net>
	<CALJ65z=vLyth5gPcD2NJ0QS+HGoeFLg8XPY4VKDGQMUVJw2mOg@mail.gmail.com>
	<54C6CD1E.7020106@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:57006 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbbAZXhf (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 26 Jan 2015 18:37:35 -0500
Received: by mail-we0-f169.google.com with SMTP id u56so11973301wes.0
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jan 2015 15:37:33 -0800 (PST)
In-Reply-To: <54C6CD1E.7020106@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>
Cc: David Mohr <damailings@mcbf.net>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, robie.basak@ubuntu.com

Ok, I just merged from him and pushed.

On Mon, Jan 26, 2015 at 3:26 PM, Rolf Fokkens <rolf@rolffokkens.nl> wrote:
> Well, to be honest I built the latest Fedora bcache-tools packages based on
> https://github.com/g2p/bcache-tools. So I'm perfectly happy with what's in
> it. If all of g2p's repo is merged into
> http://evilpiepirate.org/git/bcache-tools.git/ I'll use that one as my
> source repo again.
>
> So far I've been collaborating with Gabriel (g2p) using his Github repo as
> the starting point, assuming that's the one that will be pushed to
> evilpieprate in the end. At the moment though there are 3 pull requests
> pending (one of me) that don't get g2p's attention, I guess he's busy with
> other things. So I'll post my latest pull request here on the mailing list,
> so it can be discussed and Kent can decide if he wants to merge it.
>
>
> On 01/26/2015 10:45 PM, Kent Overstreet wrote:
>>
>> Yeah - but do you suppose you could coordinate with the Fedora package
>> maintainer, Rolf Fokkens - and make sure pulling that stuff works for
>> him? Or if you guys have different patches, just let me know where I
>> can pull them from.
>>
>> On Mon, Jan 26, 2015 at 1:24 PM, David Mohr <damailings@mcbf.net> wrote:
>>>
>>> Hi,
>>>
>>> in discussions around the Debian packaging the question came up why
>>>    http://evilpiepirate.org/git/bcache-tools.git/
>>> is the official repository when it seems like the current stable
>>> development
>>> takes place in
>>>    https://github.com/g2p/bcache-tools
>>>
>>> Would it be possible to merge Gabriel's work back into the main
>>> repository
>>> so that we can refer to evilpiepirate.org as the definitive upstream? If
>>> not, what's the relationship between the repositories?
>>>
>>> Thanks,
>>> ~David
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: Git repositories
Date: Tue, 27 Jan 2015 00:26:22 +0100
Message-ID: <54C6CD1E.7020106@rolffokkens.nl>
References: <baa05f9cf5caef3dd4101b22d13fcbae@de.mcbf.net> <CALJ65z=vLyth5gPcD2NJ0QS+HGoeFLg8XPY4VKDGQMUVJw2mOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63584 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbbAZX0Z (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 26 Jan 2015 18:26:25 -0500
Received: by mail-wg0-f49.google.com with SMTP id k14so11808065wgh.8
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jan 2015 15:26:23 -0800 (PST)
In-Reply-To: <CALJ65z=vLyth5gPcD2NJ0QS+HGoeFLg8XPY4VKDGQMUVJw2mOg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>, David Mohr <damailings@mcbf.net>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, robie.basak@ubuntu.com

Well, to be honest I built the latest Fedora bcache-tools packages based 
on https://github.com/g2p/bcache-tools. So I'm perfectly happy with 
what's in it. If all of g2p's repo is merged into 
http://evilpiepirate.org/git/bcache-tools.git/ I'll use that one as my 
source repo again.

So far I've been collaborating with Gabriel (g2p) using his Github repo 
as the starting point, assuming that's the one that will be pushed to 
evilpieprate in the end. At the moment though there are 3 pull requests 
pending (one of me) that don't get g2p's attention, I guess he's busy 
with other things. So I'll post my latest pull request here on the 
mailing list, so it can be discussed and Kent can decide if he wants to 
merge it.

On 01/26/2015 10:45 PM, Kent Overstreet wrote:
> Yeah - but do you suppose you could coordinate with the Fedora package
> maintainer, Rolf Fokkens - and make sure pulling that stuff works for
> him? Or if you guys have different patches, just let me know where I
> can pull them from.
>
> On Mon, Jan 26, 2015 at 1:24 PM, David Mohr <damailings@mcbf.net> wrote:
>> Hi,
>>
>> in discussions around the Debian packaging the question came up why
>>    http://evilpiepirate.org/git/bcache-tools.git/
>> is the official repository when it seems like the current stable development
>> takes place in
>>    https://github.com/g2p/bcache-tools
>>
>> Would it be possible to merge Gabriel's work back into the main repository
>> so that we can refer to evilpiepirate.org as the definitive upstream? If
>> not, what's the relationship between the repositories?
>>
>> Thanks,
>> ~David
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

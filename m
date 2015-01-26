From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: Git repositories
Date: Mon, 26 Jan 2015 13:45:01 -0800
Message-ID: <CALJ65z=vLyth5gPcD2NJ0QS+HGoeFLg8XPY4VKDGQMUVJw2mOg@mail.gmail.com>
References: <baa05f9cf5caef3dd4101b22d13fcbae@de.mcbf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60464 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbbAZVpD (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 26 Jan 2015 16:45:03 -0500
Received: by mail-wi0-f177.google.com with SMTP id r20so1132811wiv.4
        for <linux-bcache@vger.kernel.org>; Mon, 26 Jan 2015 13:45:01 -0800 (PST)
In-Reply-To: <baa05f9cf5caef3dd4101b22d13fcbae@de.mcbf.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: David Mohr <damailings@mcbf.net>, Rolf Fokkens <rolf@rolffokkens.nl>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, robie.basak@ubuntu.com

Yeah - but do you suppose you could coordinate with the Fedora package
maintainer, Rolf Fokkens - and make sure pulling that stuff works for
him? Or if you guys have different patches, just let me know where I
can pull them from.

On Mon, Jan 26, 2015 at 1:24 PM, David Mohr <damailings@mcbf.net> wrote:
> Hi,
>
> in discussions around the Debian packaging the question came up why
>   http://evilpiepirate.org/git/bcache-tools.git/
> is the official repository when it seems like the current stable development
> takes place in
>   https://github.com/g2p/bcache-tools
>
> Would it be possible to merge Gabriel's work back into the main repository
> so that we can refer to evilpiepirate.org as the definitive upstream? If
> not, what's the relationship between the repositories?
>
> Thanks,
> ~David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

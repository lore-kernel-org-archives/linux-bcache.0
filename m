From: John Sheu <john.sheu@gmail.com>
Subject: Re: bcache: remove nested function usage
Date: Mon, 17 Mar 2014 23:14:42 -0700
Message-ID: <CACE2HECXrffosqxkAf6DLFkfBtH8weGH9G4f+CBsApLGsFqs9Q@mail.gmail.com>
References: <1395121859-23501-1-git-send-email-john.sheu@gmail.com>
	<20140318060958.GA22933@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:48496 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaCRGVf (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 18 Mar 2014 02:21:35 -0400
Received: by mail-qa0-f52.google.com with SMTP id m5so6340393qaj.25
        for <linux-bcache@vger.kernel.org>; Mon, 17 Mar 2014 23:21:35 -0700 (PDT)
In-Reply-To: <20140318060958.GA22933@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

On Mon, Mar 17, 2014 at 11:09 PM, Kent Overstreet <kmo@daterainc.com> wrote:
>
> On Mon, Mar 17, 2014 at 10:50:58PM -0700, john.sheu@gmail.com wrote:
> > This patch fixes up some crashes seen while running bcache with the ftrace
> > function graph tracer.
>
> They need to be marked static once they're not nested

Whoops, forgot about subtract_dirty().  It is static in all the rest.

-John Sheu

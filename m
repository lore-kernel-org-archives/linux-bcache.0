From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [for-416 PATCH 1/2] bcache: Fix, improve efficiency of
 closure_sync()
Date: Fri, 5 Jan 2018 14:06:42 -0500
Message-ID: <20180105190642.GA25569@moria.home.lan>
References: <20171230230934.910-1-mlyle@lyle.org>
 <cfee0947-24bd-c45a-5219-81ae6a208069@kernel.dk>
 <dd2e9b62-684e-93fa-a827-7a12802993ce@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:44682 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbeAETGq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Jan 2018 14:06:46 -0500
Content-Disposition: inline
In-Reply-To: <dd2e9b62-684e-93fa-a827-7a12802993ce@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Jan 05, 2018 at 09:15:41AM -0800, Michael Lyle wrote:
> Jens & Kent,
> 
> On 01/05/2018 08:05 AM, Jens Axboe wrote:
> > On 12/30/17 4:09 PM, Michael Lyle wrote:
> >> +void __closure_sync(struct closure *cl)
> >> +{
> >> +	struct closure_syncer s = { .task = current };
> >>  
> >> +	cl->s = &s;
> >> +	continue_at(cl, closure_sync_fn, NULL);
> >> +
> >> +	while (1) {
> >> +		__set_current_state(TASK_UNINTERRUPTIBLE);
> >> +		smp_mb(); /* Ensure task state set before load of done flag */
> > 
> > That's why we have set_current_state().
> > 
> 
> I wrote the comment in question-- it seemed like to me set_current_state
> and a store w/ barrier, but I was nervous since I didn't write the code
> that there might be another dependency/reason.
> 
> Kent-- is there any reason to not just set_current_state(...)?

No, set_current_state() is the right way to do it

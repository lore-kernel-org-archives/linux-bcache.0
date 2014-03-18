From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: bcache: remove nested function usage
Date: Mon, 17 Mar 2014 23:09:58 -0700
Message-ID: <20140318060958.GA22933@kmo-pixel>
References: <1395121859-23501-1-git-send-email-john.sheu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38533 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaCRGHp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 18 Mar 2014 02:07:45 -0400
Received: by mail-pd0-f181.google.com with SMTP id p10so6581450pdj.40
        for <linux-bcache@vger.kernel.org>; Mon, 17 Mar 2014 23:07:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1395121859-23501-1-git-send-email-john.sheu@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: john.sheu@gmail.com
Cc: linux-bcache@vger.kernel.org

On Mon, Mar 17, 2014 at 10:50:58PM -0700, john.sheu@gmail.com wrote:
> This patch fixes up some crashes seen while running bcache with the ftrace
> function graph tracer.

They need to be marked static once they're not nested

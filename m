From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: Read cache contents cleared on boot?
Date: Sun, 08 Dec 2013 19:32:18 +0100
Message-ID: <52A4BB32.9010104@rolffokkens.nl>
References: <527ABDED.60902@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33484 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3LHScV (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 8 Dec 2013 13:32:21 -0500
Received: by mail-ee0-f50.google.com with SMTP id c41so1183848eek.9
        for <linux-bcache@vger.kernel.org>; Sun, 08 Dec 2013 10:32:20 -0800 (PST)
In-Reply-To: <527ABDED.60902@nuclearwinter.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-bcache@vger.kernel.org

On 11/06/2013 11:08 PM, Larkin Lowrey wrote:
> When I boot my cache usage returns to 1.3GB even when it was nearly full
> at shutdown (as reported by bcache-status). Are the read cache contents
> not retained across a reboot?
Same here: After running for a while bcache-status reports a Total Cache 
Used of 2.1GB. After reboot it's back to 910MB all the time. Did you get 
an explanation for this?

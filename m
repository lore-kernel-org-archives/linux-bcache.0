From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Bcache version 9
Date: Thu, 16 Dec 2010 03:21:33 -0800
Message-ID: <4D09F63D.8040406@gmail.com>
References: <20101121140808.GA6429@moria> <20101122010914.GB7688@kroah.com> <4CEB7648.8030000@gmail.com> <20101201041610.GA5891@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101201041610.GA5891@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.orglinux-fsdevel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 11/30/2010 08:16 PM, Greg KH wrote:
> True, but I thought configfs could handle "bare" config items, you might
> want to look a bit closer as to how people are using it.  But I could be
> totally wrong however.

Just in case I wasn't the only one confused, I stared at the 
documentation and examples some more... still wasn't completely sure, so 
I wrote the code, and bare attributes without a configfs item do work. I 
just switched to configfs for the stuff that was in /sys/kernel/bcache, 
it'll be in the next version.

Almost got everything done on my todo list before it's ready to be 
submitted...

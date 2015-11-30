From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Sun, 29 Nov 2015 17:49:26 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net>
References: <1448626993.2877.112.camel@suse.de> <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net> <1447419912.2616.19.camel@suse.de> <1447418245.2616.15.camel@suse.de> <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net> <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
 <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net> <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1701589203-1448848249=:5445"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [71.19.153.34] ([71.19.153.34]:58846 "EHLO mail.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbbK3Bv0 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 29 Nov 2015 20:51:26 -0500
In-Reply-To: <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Yannis Aribaud <bugs@d6bell.net>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1701589203-1448848249=:5445
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT


(intentional top-post)

There are a number of stability patches that haven't found their way to 
mainstream yet.  We have been using bcache for over a year now with great 
stability and no dataloss with these patches.  Try pulling the branch that 
I just set up to maintain these commits:

https://github.com/ewheelerinc/linux/commits/bcache-patches-for-3.17

git add remote ewheelerinc https://github.com/ewheelerinc/linux.git
git fetch ewheelerinc
git merge ewheelerinc/bcache-patches-for-3.17

This is a clone of Linus's tree circa 3.17-rc1 so git merge should bring 
this in cleanly to any later branch.  You could cherry-pick as well.  
I've tested and this will also merge cleanly into v4.1.13.

Note that I've not written any of these patches, I just keep them around 
since they make the difference between stable and unstable for bcache.  
The original authors and their discussions are included in the commit 
notes.




--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298

On Fri, 27 Nov 2015, Yannis Aribaud wrote:

> 27 novembre 2015 13:23 "Johannes Thumshirn" <jthumshirn@suse.de> a écrit:
> > Sorry to disappoint you, but I couldn't find anything that could be related to
> > your lockup.
> 
> Well even I you didn't found anything, thank you for your time.
> 
> I just upgraded my kernel to 4.2.6 vanilla to see if this lockup occurs again.
> 
> Regards,
> -- 
> Open is better
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-1701589203-1448848249=:5445--

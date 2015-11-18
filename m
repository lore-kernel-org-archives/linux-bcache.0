From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH v3 7/7] Smack: Handle labels consistently in untrusted
 mounts
Date: Tue, 17 Nov 2015 18:50:52 -0600
Message-ID: <20151118005052.GA131992@ubuntu-hedt>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <1447778351-118699-8-git-send-email-seth.forshee@canonical.com>
 <alpine.LRH.2.20.1511181112090.1460@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34010 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbbKRAvm (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 17 Nov 2015 19:51:42 -0500
Received: by ioir85 with SMTP id r85so37752242ioi.1
        for <linux-bcache@vger.kernel.org>; Tue, 17 Nov 2015 16:51:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.20.1511181112090.1460@namei.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Casey Schaufler <casey@schaufler-ca.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>

On Wed, Nov 18, 2015 at 11:12:51AM +1100, James Morris wrote:
> On Tue, 17 Nov 2015, Seth Forshee wrote:
> 
> > +	sbsp = inode->i_sb->s_security;
> > +	if ((sbsp->smk_flags & SMK_SB_UNTRUSTED) &&
> 
> Where is SMK_SB_UNTRUSTED defined?
> 
> I can't see it in this patch series, mainline or security next.

Eric's already applied a few of my patches to a branch in his tree,
including the one that defines this. See the for-testing branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git,
specifically
https://git.kernel.org/cgit/linux/kernel/git/ebiederm/user-namespace.git/commit/?id=36979551f2345d4e20714c1fc53d6a15c87f8b64.

Thanks,
Seth

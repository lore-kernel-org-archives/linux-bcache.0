From: Justin Cinkelj <justin.cinkelj@xlab.si>
Subject: Estimating required SSD cache size
Date: Mon, 3 Nov 2014 00:40:47 +0100 (CET)
Message-ID: <1470570594.6038.1414971647696.JavaMail.zimbra@zimbra.xlab.si>
References: <1044179531.6009.1414970878221.JavaMail.zimbra@zimbra.xlab.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.xlab.si ([91.217.255.70]:57375 "EHLO spamtitan.xlab.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaKBXt6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 2 Nov 2014 18:49:58 -0500
In-Reply-To: <1044179531.6009.1414970878221.JavaMail.zimbra@zimbra.xlab.si>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi

I have machine I want to add (r/w) SSD cache to. Question is, how much? Now I guess an obvious answer could be given by how many sectors are re-read/re-written from/to the HDDs. (Large) sequential IO should be ignored here. 

Does anyone know for some tool give 'advice' about suitable cache size?

Thank you, Justin

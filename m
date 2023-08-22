Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF99EE49A3
	for <linux-bcache@archiver.kernel.org>; Wed, 23 Aug 2023 01:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjHWBne (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 22 Aug 2023 21:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjHWBn2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Aug 2023 21:43:28 -0400
X-Greylist: delayed 919 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 18:43:26 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B1510D
        for <linux-bcache@vger.kernel.org>; Tue, 22 Aug 2023 18:43:26 -0700 (PDT)
X-AuditID: cb7c291e-06dff70000002aeb-4f-64e54bbca6c3
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id 2B.FB.10987.CBB45E46; Wed, 23 Aug 2023 04:58:52 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=hz55lQmDwARG+MMadiCGMAN5xFNmK6pAuE51cVFp9t4eLwf7OgfOgm+I9fP0oZk02
          9FYKVSgZ0CsZMqww2UpvK4eW04sQ94/4JcZrUQ4r92BFeCbuBLCXO74xiHhM4G3oh
          vlqPS+tVxo1o7qGeg7PzcEhrvF2qUbngZ721tVgFI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=DDk6PfLJwbV+lZttbK0vV00a7+6f6M39/A48Sjp4HaocZ/3couUnZDAHpkrqQrB5H
          vmHoMgmiJIEIsxwtU0K0Ot0K4z76IFv7R8boFErjT6pZ4ehT968epVdpVLCI1l52G
          fEL7IQd04cPN5V1f8C4GI5fXf7Hx/HBloQ5+5FNPw=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 04:30:58 +0500
Message-ID: <2B.FB.10987.CBB45E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     linux-bcache@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 16:31:12 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVyyUKGW3eP99MUg4VnjCyObbvG5MDo8XmT
        XABjFJdNSmpOZllqkb5dAlfGknUXWAp2M1e09S9iaWB8zNTFyMkhIWAisefIEsYuRi4OIYE9
        TBLXTxxnBnFYBFYzS+xc+58dwnnILLH36h02iLJmRonffb/YQPp5BawlJn5azAhiMwvoSdyY
        OgUqLihxcuYTFoi4tsSyha+BxnIA2WoSX7tKQMLCAmISn6YtYwcJiwgoSDxaWA8SZhPQl1jx
        tRlsIouAqsSBG/NYQWwhASmJjVfWs01g5J+FZNksJMtmIVk2C2HZAkaWVYwSxZW5icBQSzbR
        S87PLU4sKdbLSy3RK8jexAgMw9M1mnI7GJdeSjzEKMDBqMTD+3PdkxQh1sQyoK5DjBIczEoi
        vNLfH6YI8aYkVlalFuXHF5XmpBYfYpTmYFES57UVepYsJJCeWJKanZpakFoEk2Xi4JRqYIyS
        y3+/Pztm5+HzzrdvbU1bYhf+LPxfqoNr59FSg9wEhwMX5eP3fzFQ28/52WNjJOOHmgjNB9GH
        Hn64+S6A8d3UT3eq7zrYPTyw3bai7RCnXlV0ivi1K9e/7P7xMPDS3u8iFyxbuZwauc7snMBZ
        +qHinElCwLfAg82Kirxeiy7mcsaxOfDxVCqxFGckGmoxFxUnAgC0r5J7PwIAAA==
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China


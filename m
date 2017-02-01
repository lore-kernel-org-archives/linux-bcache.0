From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: bcache-tools [branch: dev] throws Assertion `!(bcache_init())'
 failed.
Date: Wed, 1 Feb 2017 15:06:01 +0100
Message-ID: <b5d03d84-47c6-8f05-6851-2c6ac8eed035@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:63118 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbdBAOGx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Feb 2017 09:06:53 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,
bcachefs-tools at b33fc829 throws assertion:
# bcache
bcache: libbcache/super.c:2503: __call_bcache_init: Assertion
`!(bcache_init())' failed.

Marcin

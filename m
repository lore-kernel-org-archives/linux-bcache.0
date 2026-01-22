Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410B3366DAB;
	Thu, 22 Jan 2026 08:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769069112; cv=fail; b=bNoA9TpZcgpSEyTd67Wi6xXPmgpad1OOJYwy0ENx46vrhFCze+YoTVoAjrwKareSaseoz/P2Jo3jNcUK/LN1C9KIVkwPSUsnHtA8W2O8vyg56vf4HbzDx9WWhtDtb69idFXwdsc1BSrRzdeNXwp6SH1LcBwvyzodsYxmhFBkXt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769069112; c=relaxed/simple;
	bh=t3MYjZlMi0XvOkkKu7p/mpkySq48SIB7vO0wNTNdrCo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jzBeERi9i4SPcCdy/40zA/FNHUd0uCVNAOwG5mxN17mP2XBEtCdsa+JNitTx1KDpoj4icLxEr2aChbTLNRM3EesiDMT3AeOdFZjxpedrCRGxqgOpP+CRl3P7P+1NFuDG4BbKsWqyMVkDkYVbyO5wLc8RZKuqJxpNThgMB6TBL+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KwTeWL9v; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=E0k7YMWX; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KwTeWL9v";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="E0k7YMWX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769069110; x=1800605110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t3MYjZlMi0XvOkkKu7p/mpkySq48SIB7vO0wNTNdrCo=;
  b=KwTeWL9viWgo7PxC5saE0eVAUgSHHHbVCLZX2gfhnzq3RKwXsrCbdp/7
   eEw7P28ejUa0Af7iW1hFBHaEdZ5Lt3nGIfFMcTvjY84EVVflHwfAjWQA4
   4DFUdFSG9Cf5kINm/OuPZw4MDXVrwJDml0MGLhDWzCLuK2BdkR+7+u/Hz
   juzZgz/FfSWjKs5XzEo8uebnjb/G8EgRW2R0MoPu4rhzMe7XmdhK3v852
   xblX++OKy45w1fmF3BCnLJunoy2uYiV3KVPJwS18sPG5Z5Hn1cseaxGMP
   pMKZXgNaZKOLAhJy1or5HOKvPkqe1ZwtB0lg3/swoYdTIM9js6PVJXfmi
   A==;
X-CSE-ConnectionGUID: LqZViXBEQuSIV8SyGfstpw==
X-CSE-MsgGUID: ZRSUz8vcTLiDK2SMkON6+w==
X-IronPort-AV: E=Sophos;i="6.21,245,1763395200"; 
   d="scan'208";a="138509382"
Received: from mail-southcentralusazon11013045.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.45])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jan 2026 16:05:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2Ex9XwnhJS03cDYqRtMsHBG/e/OjuXaDxGQ6seWPn2UZThctz8NTyCYsw4KM1rCG4q9ufMIs+grvJqPDeGo/oPPiqpDhQoLmX2swETklYdFnr+tGFw4E3COaTyXjKINxhKEjo3+JRjIMEn99fP7l03enKqYNsI/oS2ujo4pGJJZKt6SAGbnrPhOlBNKu5w8UPZZKwHqKRAYrYRJP1850o5H7sbR440v3HEZ9gBAensKV+BjFcyvR24iUegcS/0UqgEC1BWGQr/hQSbfttQXpq26Ch7sOLWQ+I20Y3f0jFT5Lr5x5D0EoPCJOxgBNR+j97vSDYocJa1brjDE4MjsHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCpnpRipwpxaaG6Jr77o0wX9sKslJPL8SKi2m84OPUI=;
 b=C97x08zaYOW4BGRBX8e6odHF9MKOCc4rBMuSXmrSHpWJ7Hbbj89vMwazy2IttUYU9V6FJgSQWX9TguXCuuCrtcNQogzAS0K8cjPFJpkRfDaeZuOYwOLguE1F4CiWoIsRUMzsPD6+mUdIq62+z90Xmv8Kq+0N/PhnQa2RDEf+3dM2/gbNypw+ZwYv2hx14wY7DrMq72BEC6dw/N0cAZUJlaBXwLROlT9TmK2ftXyg9ihlOoUmIgYr7JtJBgFLjLnJ51hOc6r/gUAGboZdvMQVm+nE76BXUjBxhSv6W7wCubq3Be3LPJxDBjnk919zVGBREjqe5m2zVZwQ62DBxeJq6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCpnpRipwpxaaG6Jr77o0wX9sKslJPL8SKi2m84OPUI=;
 b=E0k7YMWXMV6P3CuHuBkRUvDtettRIzjJ1NvhDByDLAMIl0G3Aza9h40+b5aVbEeWECW0ok9D4Wz7UVzoZ1L3H93ep5+3gDx7G3G61GcU+QnK1C0lkjUeehAM6SkeQD1k9KkXfOxO2hkFoI+8R8mwWST1wSvrAD+4awrPf6oMY0Q=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CH2PR04MB6982.namprd04.prod.outlook.com (2603:10b6:610:92::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.3; Thu, 22 Jan
 2026 08:05:05 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9564.001; Thu, 22 Jan 2026
 08:05:05 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Daniel Wagner <dwagner@suse.de>
CC: "hch@infradead.org" <hch@infradead.org>, Stephen Zhang
	<starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, Coly
 Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v2 1/2] bcache: add bcache/001
Thread-Topic: [PATCH blktests v2 1/2] bcache: add bcache/001
Thread-Index: AQHciuNiyGXXgN7Vs0WfxsaTxDRACbVd1dmA
Date: Thu, 22 Jan 2026 08:05:04 +0000
Message-ID: <aXHWBswguTmf8VCx@shinmob>
References: <20260121-bcache-v2-0-b26af185e63a@suse.de>
 <20260121-bcache-v2-1-b26af185e63a@suse.de>
In-Reply-To: <20260121-bcache-v2-1-b26af185e63a@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CH2PR04MB6982:EE_
x-ms-office365-filtering-correlation-id: 661f18bc-ebe0-49b4-2ac2-08de598cf39a
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|38070700021|18082099003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?BiYn3LDAzV5RZt/yltCRKIkvodAD13pWRa4tYakX5AReUz0nIc9PbsvgZnlw?=
 =?us-ascii?Q?T1xKH3FoWC7d2gv5tWZ4WIfsFDT2q/PG7BsVOciGb87Q4ezEqvBQIxkhw5hM?=
 =?us-ascii?Q?ljj1P633A6nG1hbkJ5/VRzg7M1pbr3WynMkZYFDqpyR6jcXyTwB/2HmLOrFF?=
 =?us-ascii?Q?9ituoO98EaGldOvfM6fFo/8rG5fq5p2vJf4JyoqefbIrL7qJukZ5vDGAQN0k?=
 =?us-ascii?Q?9DEo0LYTwnahxuhDA8MyfA3XuZEBGLztSucgJ9OY72uU9i/0Q8i3umLxiZd+?=
 =?us-ascii?Q?P+fJ4oYgFi2yS7n7VcjaemjMfM6rsprBGckispiJ7CnKDD73yd3wpvtuiFeC?=
 =?us-ascii?Q?ry7FxlTFdnUI6HE248l4Cby1bAfarLCSUOcyD7RagGTPOt/OFCgNJSUxnRog?=
 =?us-ascii?Q?VUiPCBe8SWew8PT4GB9+isgc0S/BpAGkEw77TBAboBWVmkqRHk36ls4h/9Hv?=
 =?us-ascii?Q?KYJTx/gyuVEwXmR5Ro8/9xA8INRxEDxHutnqbSYnAr87WQ3skrxlZuRUgQXC?=
 =?us-ascii?Q?xvDfNbhZBluVXMVTy8mC36AXYDcS8GMAa4x5+D9t3URP1NNTthTmPJhCQ9Y5?=
 =?us-ascii?Q?7WpuCRZpxg+ltILCgTT4U019rma+lnGPV8Zisj6lbF5TgGFgpIdDIo5lBcvx?=
 =?us-ascii?Q?TQR7Fg346qzruMOT8ZZEwuEOng/q3YZrSzP4n730PWi/+qYUD0wiv8El8ErT?=
 =?us-ascii?Q?qxVNgAmqPWANy37tEpOtEeM/htVcu9ulRuSbXl1qUL5t4mkPhQZJk+ywYlp2?=
 =?us-ascii?Q?1U3dnq7of3ztlUqpRIxttlPsLRLyak3cbstW8SNlm2zzxZhYfhuJe/U01dWK?=
 =?us-ascii?Q?nyJHgSPb/q+aH2EBvbRCLi/tHmVEfleb1MBa7C49LYUE+U88SVheHxa4zNLd?=
 =?us-ascii?Q?ZfCckAAXk5XJBn9cAvhngDGwhOokagG2tTf99frgTjkeltixLbxCLVdz1+ns?=
 =?us-ascii?Q?buzehC1yIoLeAjWAcgfnQ17lRgwFD+lAgfWIFOKlGi1pR6J2JMIg8oPgj/VS?=
 =?us-ascii?Q?N5VmgaSviQ3PJX477jPOVlxlMt6O/kyR0UcAGFoGT1AhSKUjR+j+zsIZDUcN?=
 =?us-ascii?Q?AlMRSgzzHMXIptjUq8xOgiaS2YyxCe/obRocP5ObDdfuI5PAJnVs9u8P5OSg?=
 =?us-ascii?Q?1Jf7K0MeYv8FF69fhyTuAcP9VE+SyzPNJM0qvZG0x4C3qBSi3XO5Uwxmvq1d?=
 =?us-ascii?Q?36H1y20junBQF9Teq+MdqU3qtOKd/W/9IzYaDPkEmkAU0Xj7vSyEieFGQSG7?=
 =?us-ascii?Q?ViKYNMC1W+BlfvApFnCZlWHgjj2sfx0yq6igREujNTs5H0HKj+NOcjN3rAO9?=
 =?us-ascii?Q?Ye8cwq1Xq6msDuILlFqpWKwwtobYHkbrgGoxwMV7Cfo2JwmcqExENEAfph6Q?=
 =?us-ascii?Q?SHRK5O59xdoHSQbe+fehODB8Px/i9KzqG25y9RpQtGhz2GXeTkCZqAQ0IhmA?=
 =?us-ascii?Q?M1wkRkYJ3wb/Eh5f4WbblfHqiQ9hcqTsxWTSKGATWqAi5aUUNkT3zW3KVjyZ?=
 =?us-ascii?Q?vKtbkMCgzJYWY44bIVzf1ZLQNcFPRMNbANCAtSh1pWEl3c4SvMgT2B1wRTMl?=
 =?us-ascii?Q?d+U+LZ7wb04RKdV1FcHn1PnBjqE3Mwx+5c48nC2Iqh7vVIMd/tGxVEghtjOz?=
 =?us-ascii?Q?uchziBq2AtcauaC6QGxPph8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(38070700021)(18082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?bmoJ9JCGQGnEmAQmpEjLwz6QiIZ5M0OYcB58ZzvGj16bsN86fMPd9dmfY6nS?=
 =?us-ascii?Q?dqcHnPjaKc1ExlV4XhXl18Ys5/Kh1Ts0s+q3R5i1Pb4SFXGZGARPU4uBTNMu?=
 =?us-ascii?Q?H5hKM8vlcBXDcZ1doxZNZW3uinOL3lMMYQ3wADJfmuAjMWKgU2DFQHN2uQ2w?=
 =?us-ascii?Q?OMJZi7YYsnPTIk499TL/LzMm6XShNeiuekkUcDHb57ZbQkgckXFd0Lbo0Nz0?=
 =?us-ascii?Q?VWkDxoL2ws2f1VesnJvy2vgfTA1TjEYE0bIxfjPQrV+Rri0eXmUhR9TXiBUx?=
 =?us-ascii?Q?jpj6iT3ppiGh7ZUDCsQd5yK10QPPXc7VB69Y5d88ckLOw4JWAG+FPmckKjCQ?=
 =?us-ascii?Q?ScbZWHjVyGTLRTwqkx7mDezT5kCdjNM3ZgH4LqE6XZgrnid7OiyYI1f03FCw?=
 =?us-ascii?Q?LBNHsLTumTL8XRfV+c5dgdSCoe2tCagxkPZujxnc/vVHWkc5wiyA/ujV1iwO?=
 =?us-ascii?Q?wIPSm2w8lxH0sgStPcJiRqdFGYbHMKawOF8xvas7x2HNApXfgjlUpS4E/H0D?=
 =?us-ascii?Q?VOalmjEw6RV8aBplvttsKWaUrmkVDUTfyBQg1tByf+utI5YYl2e0nhYfSkmh?=
 =?us-ascii?Q?6DS9TL+TeKqImHgBYogo3S413y0O/OXxGDrz+jhG0kQWItB3zjizbPvMNNGN?=
 =?us-ascii?Q?sDeomibUq9+77ndELCghNxPn2l6TIGNid3OwkKKRu8/NJ5BG5bDCWM0rAXLE?=
 =?us-ascii?Q?n34GwR4DwBvlfFQ3N2gmSLbCH/9TySuQPzhwGPN/dEzvHo5PD0RvQZZyc8LP?=
 =?us-ascii?Q?Vk9CullSiSWgJvrIxMH5xpOM6xTs/NK7FBI+1jw872FoIwmWI91wupwiUz6f?=
 =?us-ascii?Q?zsrsHlghl0Kk0pVG13VeqPAMLt3CwWnpnlby13zjwlU4kF2r5b2o4FeTAY3A?=
 =?us-ascii?Q?fDmtXHfc6WSD2aQeVtFUjtA/rtcHL8dPlqULl/sDA96ai1apMBiqHnjfDt4O?=
 =?us-ascii?Q?e3ECvasUD5nNvDWI8FOx5rK+GuiyN3uHtTWQZz0UYkyth/tWuRrTyud8pcTO?=
 =?us-ascii?Q?ew/FKSC0Jx/CIgZhV2E0tkLyD5Pq/5YgSQSdRmT4AA5dSUVL+H+ZFzpTliYd?=
 =?us-ascii?Q?/ZEklY9b3XHZa5Dy4QKfZd1JXZ50OI+v+eAfG6RwnLv3E9oMWbxFuZxCegnH?=
 =?us-ascii?Q?dPUS6/CySRif64dN7dD9layazTmJ703DiItmfewKurdSV06+cV8eDTiRgIgM?=
 =?us-ascii?Q?hv/YFVPk2BeQ5KLE0FgkEPVicO6JFNZPNOi++9nhD66X1RhjR2Wjxq3CuCAy?=
 =?us-ascii?Q?/FhCtQgHLlfdx3Rfxn1eubczcCU1e/WpAhOIGfW0TwTw4NyTG0omnSQa78KT?=
 =?us-ascii?Q?3LfRN2S6wrLxeOXwGb9YACBf51iMRRWe4JZWuRBq160FGUD6WuvshmLUINGn?=
 =?us-ascii?Q?SxL7c+h9YsBUNDmXcGgfLkIHfFBsHPY5TICDfIbPJYCpgB4abwRFpY/qbwM+?=
 =?us-ascii?Q?C5DhccXOiByG+ZLVDTvJSbqkYb1ff/eHij5l+6bDXFLgyfi2Bf9blR3DKEq+?=
 =?us-ascii?Q?X+fq5BSXi3WfFoL5wutjZCWxDaQoOyhVr7D82xW3cTW6RGjuD2IV1KW3LZwV?=
 =?us-ascii?Q?XuOEvSHSxlnmV2gxrvL0baQlgYKk+eWnbxITNOAOJaUYerk/NVab7A07hvmg?=
 =?us-ascii?Q?0PWbZaRu90tcUSdSPCwEp9SzWV9qTJImaqb5jZZJ7anmzsffUleSKTzJWC9m?=
 =?us-ascii?Q?lNampuGO4ZgAy0E5b7YCZ9Rq1m5lvg4HXXm7hrpsUjCu1R/P4ZfngVY6JiCY?=
 =?us-ascii?Q?v9fFD1GBNOV1MKI5huZWP5TrJCBaE5E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <036C38C4B42B3C4FA4ADCDB449CC8A04@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E6LpNIBqmD7tBecf3U1HbhPErOkS8qyrFqc4Eav/3LLwPXsQ2MSIXDzgzoTqsuRlJZ1HP+L8P9uDI9DTd1mW1Cs/wzrRyQ025okyShaHTsaeMoG7K7ZpJN+8w7bbPIdMzS7BdMJdxwg2RbW1RgjvXP6YtZZkxDKYfWDDKTYfe2dFLc5iz48pL/XrpSpF68AlcyRcrZPXaX1hHQKTXX2i/OzOJHvyj4h13VkLZrx6QMMBiPDLEKm0XEUK37cFVLtwIfFMnr9J+yKaer6D+EK9plkFR+4tCUFdhrPfoMiX6gdviVjIHOuuI00JmqcdnxxAAVEAbg5Ud9Qa3EMYoK8GV2+MYYIwLU8mOns5y0f5WOAHqiYs8dFO2seDLMpxiiQ9saeGdQxFIGR4vbBQrWCBxBUVpmBOjDOJ+njcMa0K1EOcrL7IuNcvEQK+noIWXQhZy8d8QZTwcr9wxD0R+gjCSaVYFR81pImVaOO2bg+kC1YseSJUzeBxVKoq7PR7KGP5VnG8BDc5Nv/tNJppfKDJkoj2QtDdJEOrpj5oX+lLtDn9HLuWGfAKpMyADr626grrX14L1B/Oe2l3Z+haRxwNe9cgaEjdsMKDdUWAhWo5SblwlwPGDld9vhIUuiBmp7Sy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 661f18bc-ebe0-49b4-2ac2-08de598cf39a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2026 08:05:05.0096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CKckhlQemgKDmE4rrHX64tsrhFFu4hzWRgJtsTvoQvtN4MWx5DB1MJvUuhV5b9hj2cO4SOkph8PIbaxNdsQj95cSJqy4aufwZmmm/YNd/70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6982

Hi Daniel, thank you for working on this. It's great to extend the test
coverage :)

Please find my review comments in line. I ran the new test case, and observ=
ed a
failure. I noted my findings about the failure as one of the inline comment=
s.

On Jan 21, 2026 / 15:36, Daniel Wagner wrote:
> So far we are missing tests for bcache. Besides a relative simple
> setup/teardown tests add also the corresponding infrastructure. More
> tests are to be expected to depend on this.
>=20
> _create_bcache/_remove_bcache are tracking the resources and if anything
> is missing it will complain.
>=20
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  tests/bcache/001     |  32 +++++++
>  tests/bcache/001.out |   1 +
>  tests/bcache/rc      | 259 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 292 insertions(+)
>=20
> diff --git a/tests/bcache/001 b/tests/bcache/001
> new file mode 100644

To be consistent with other test case files, I suggest to set the file mode=
 755.

> index 000000000000..4a6e01113b6b
> --- /dev/null
> +++ b/tests/bcache/001
> @@ -0,0 +1,32 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0

Most of blktests files specifies GPL-3.0+. If there is no specific reason,
I suggest GPL-3.0+. Same comment for tests/bcache/rc.

> +# Copyright (C) 2026 Daniel Wagner, SUSE Labs
> +#
> +# Test bcache setup and teardown
> +
> +. tests/bcache/rc
> +
> +DESCRIPTION=3D"test bcache setup and teardown"
> +
> +requires() {
> +	_bcache_requires
> +}

Do you foresee that all bcache/* test cases have this _bcache_requires call=
?
If so, I suggest to,
 - rename _bcache_requires() in tests/bcache/rc to group_requires(), and
 - drop the three lines above from bcache/001.
group_requires() is called once before start testing this bcache group.

> +
> +test_device_array() {
> +	echo "Running ${TEST_NAME}"
> +
> +	if [[ ${#TEST_DEV_ARRAY[@]} -lt 3 ]]; then
> +		SKIP_REASONS+=3D("requires at least 3 devices")
> +		return 1
> +	fi
> +
> +	 _create_bcache \
> +		--cache "${TEST_DEV_ARRAY[0]##*/}" \
> +		--bdev "${TEST_DEV_ARRAY[1]##*/}"
> +	 _remove_bcache
> +
> +	 _create_bcache \
> +		--cache "${TEST_DEV_ARRAY[0]##*/}" \
> +		--bdev "${TEST_DEV_ARRAY[1]##*/}" "${TEST_DEV_ARRAY[2]##*/}"
> +	 _remove_bcache
> +}
> diff --git a/tests/bcache/001.out b/tests/bcache/001.out
> new file mode 100644
> index 000000000000..f890aed2736c
> --- /dev/null
> +++ b/tests/bcache/001.out
> @@ -0,0 +1 @@
> +Running bcache/001
> diff --git a/tests/bcache/rc b/tests/bcache/rc
> new file mode 100644
> index 000000000000..3dba6c85b1ee
> --- /dev/null
> +++ b/tests/bcache/rc
> @@ -0,0 +1,259 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Daniel Wagner, SUSE Labs
> +
> +. common/rc
> +
> +declare -a BCACHE_DEVS=3D()
> +declare -a BCACHE_BDEVS=3D()
> +declare -a BCACHE_CSETS=3D()
> +
> +BCACHE_MAX_RETRIES=3D5
> +
> +_bcache_requires() {
> +	_have_kernel_options MD BCACHE BCACHE_DEBUG AUTOFS_FS
> +	_have_program make-bcache
> +	_have_crypto_algorithm crc32c
> +}

As noted above, you may want to rename _bcache_requires() to group_requires=
().

> +
> +_bcache_wipe_devs() {

Nit: "local dev" can be added here.

> +	for dev in "${BCACHE_DEVS[@]}"; do
> +		# Attempt a clean wipe first
> +		if wipefs --all --quiet "${dev}" 2>/dev/null; then
> +			continue
> +		fi
> +
> +		# Overwrite the first 10MB to clear stubborn partition tables or metad=
ata
> +		if ! dd if=3D/dev/zero of=3D"${dev}" bs=3D1M count=3D10 conv=3Dnotrunc=
 status=3Dnone; then
> +			echo "Error: dd failed on ${dev}" >&2
> +		fi
> +
> +		# Try wiping again after clearing the headers
> +		if ! wipefs --all --quiet --force "${dev}"; then
> +			echo "Warning: Failed to wipe ${dev} even after dd." >&2
> +		fi
> +	done
> +}
> +
> +_bcache_register() {

When I did trial run, the test case bcache/001 failed with the message belo=
w.

bcache/001 =3D> nvme1n1 nvme2n1 nvme3n1 nvme4n1 (test bcache setup and tear=
down) [failed]
    runtime  8.406s  ...  12.789s
    --- tests/bcache/001.out    2026-01-22 13:55:00.510094421 +0900
    +++ /home/shin/Blktests/blktests/results/nvme1n1_nvme2n1_nvme3n1_nvme4n=
1/bcache/001.out.bad 2026-01-22 16:21:47.686976578 +0900
    @@ -1 +1,3 @@
     Running bcache/001
    +ERROR: bcache registration interface not found.
    +WARNING: Could not find device node for UUID b854b766-8e08-42b5-b7cc-e=
137fd78ca51 after 5s

I found that when the bcache driver is loadable and not yet loaded, the
make-bcache command call loads the driver. However, it takes time for
kernel to prepare /sys/fs/bcache/register. Hence the error message above.
I suggest to add a hunk below here, to wait for the register file get ready=
.
With this change, the failure disappeared in my test environment.

       local dev err_msg timeout=3D0

       while [[ ! -w /sys/fs/bcache/register ]] && (( timeout < 10 )); do
               sleep 1
               (( timeout ++ ))
       done

> +	if [[ ! -w /sys/fs/bcache/register ]]; then
> +		echo "ERROR: bcache registration interface not found." >&2
> +		return 1
> +	fi
> +
> +	for dev in "${BCACHE_DEVS[@]}"; do
> +		if ! echo "${dev}" > /sys/fs/bcache/register 2>/tmp/bcache_err; then
> +			err_msg=3D$(< /tmp/bcache_err)
> +
> +			if [[ "${err_msg}" !=3D *"Device or resource busy"* ]]; then
> +				echo "ERROR: Failed to register ${dev}: ${err_msg:-"Unknown error"}"=
 >&2
> +			fi
> +		fi
> +	done
> +}
> +
> +_create_bcache() {
> +	local -a cdevs=3D()
> +	local -a bdevs=3D()
> +	local -a ARGS=3D()
> +	local bucket_size=3D"64k"
> +	local block_size=3D"4k"
> +
> +	_register_test_cleanup _cleanup_bcache
> +
> +	while [[ $# -gt 0 ]]; do
> +		case $1 in
> +			--cache)
> +				shift
> +				# Collect arguments until the next flag or end of input
> +				while [[ $# -gt 0 && ! $1 =3D~ ^-- ]]; do
> +					cdevs+=3D("$1")
> +					shift
> +				done
> +				;;
> +			--bdev)
> +				shift
> +				# Collect arguments until the next flag or end of input
> +				while [[ $# -gt 0 && ! $1 =3D~ ^-- ]]; do
> +					bdevs+=3D("$1")
> +					shift
> +				done
> +				;;
> +			--bucket-size)
> +				bucket_size=3D"$2"
> +				shift 2
> +				;;
> +			--block-size)
> +				block_size=3D"$2"
> +				shift 2
> +				;;
> +			--writeback)
> +				ARGS+=3D(--writeback)
> +				shift 1
> +				;;
> +			--discard)
> +				ARGS+=3D(--discard)
> +				shift 1
> +				;;
> +			*)
> +				echo "WARNING: unknown argument: $1"
> +				shift
> +				;;
> +		esac
> +	done
> +
> +	# add /dev prefix to device names
> +	cdevs=3D( "${cdevs[@]/#/\/dev\/}" )
> +	bdevs=3D( "${bdevs[@]/#/\/dev\/}" )
> +
> +	# make-bcache expects empty/cleared devices
> +	BCACHE_DEVS+=3D("${cdevs[@]}" "${bdevs[@]}")
> +	_bcache_wipe_devs
> +
> +	local -a cdevs_args=3D()

Nit: "local dev" can be added here.

> +	for dev in "${cdevs[@]}"; do
> +		cdevs_args+=3D("--cache" "${dev}")
> +	done
> +
> +	local -a bdevs_args=3D()
> +	for dev in "${bdevs[@]}"; do
> +		bdevs_args+=3D("--bdev" "${dev}")
> +	done
> +
> +	local output cmd

"cmd" is array, then, I guess you meant,

        local -a cmd
	local output

> +	cmd=3D(make-bcache \
> +		--wipe-bcache \
> +		--bucket "${bucket_size}" \
> +		--block "${block_size}" \
> +		"${cdevs_args[@]}" \
> +		"${bdevs_args[@]}" \
> +		"${ARGS[@]}")
> +
> +	output=3D$("${cmd[@]}" 2>&1)
> +	local rc=3D$?
> +	if [[ "${rc}" -ne 0 ]]; then
> +		echo "ERROR: make-bcache failed:" >&2
> +		echo "$output" >&2
> +		return 1
> +	fi
> +
> +	local cset_uuid
> +	cset_uuid=3D$(echo "$output" | awk '/Set UUID:/ {print $3}' | head -n 1=
)
> +	if [[ -z "${cset_uuid}" ]]; then
> +		echo "ERROR: Could not extract cset UUID from make-bcache output" >&2
> +		return 1
> +	fi
> +	BCACHE_CSETS+=3D("${cset_uuid}")
> +
> +	local -a bdev_uuids
> +	mapfile -t bdev_uuids < <(echo "$output" | awk '
> +	  $1 =3D=3D "UUID:" { last_uuid =3D $2 }
> +	  $1 =3D=3D "version:" && $2 =3D=3D "1" { print last_uuid}
> +	')
> +
> +	udevadm settle
> +
> +	_bcache_register
> +
> +	for uuid in "${bdev_uuids[@]}"; do
> +		local link found attempt
> +
> +		link=3D/dev/bcache/by-uuid/"${uuid}"
> +		found=3Dfalse
> +		attempt=3D0
> +
> +		while (( attempt < BCACHE_MAX_RETRIES )); do
> +			if [[ -L "$link" ]]; then
> +				BCACHE_BDEVS+=3D("${uuid}")
> +				found=3Dtrue
> +				break
> +			fi
> +
> +			(( attempt++ ))
> +			sleep 1
> +		done
> +
> +		if [[ "$found" =3D=3D "false" ]]; then
> +		   echo "WARNING: Could not find device node for UUID ${uuid} after ${=
BCACHE_MAX_RETRIES}s" >&2

Two spaces are used for the indent above.

> +		fi
> +	done
> +}
> +
> +_remove_bcache() {
> +	local uuid
> +
> +	for uuid in "${BCACHE_BDEVS[@]}"; do
> +		local dev_path
> +
> +		dev_path=3D$(blkid -U "${uuid}")
> +		if [ -n "$dev_path" ]; then
> +			local dev_name
> +
> +			dev_name=3D"${dev_path##*/}"
> +			if [ -f "/sys/block/${dev_name}/bcache/stop" ] ; then
> +			   echo 1 > "/sys/block/${dev_name}/bcache/stop"

Same here.

> +			fi
> +		fi
> +	done
> +
> +	for uuid in "${BCACHE_CSETS[@]}"; do
> +		if [ -f /sys/fs/bcache/"${uuid}"/unregister ] ; then
> +		   echo 1 > /sys/fs/bcache/"${uuid}"/unregister

Same here.

> +		fi
> +	done
> +
> +	udevadm settle
> +
> +	local timeout
> +	timeout=3D0
> +	for uuid in "${BCACHE_CSETS[@]}"; do
> +		while [[ -d "/sys/fs/bcache/${uuid}" ]] && (( timeout < 10 )); do
> +			sleep 0.5
> +			(( timeout++ ))
> +		done
> +	done
> +
> +	_bcache_wipe_devs
> +
> +	BCACHE_CSETS=3D()
> +	BCACHE_BDEVS=3D()
> +}
> +
> +_cleanup_bcache() {
> +	local cset dev
> +
> +	shopt -s nullglob
> +	for dev in /sys/block/bcache* ; do
> +		[ -e "${dev}" ] || continue
> +
> +		dev=3D$(basename "${dev}")
> +		echo "WARNING: bcache device ${dev} found"
> +
> +		if [[ -f /sys/block/"${dev}"/bcache/stop ]]; then
> +			echo 1 > /sys/block/"${dev}"/bcache/stop 2>/dev/null || true

Do we need "|| true" here?

> +		fi
> +	done
> +
> +	for cset in /sys/fs/bcache/*-*-*-*-*; do
> +		if [[ -d "${cset}" ]]; then
> +			echo "WARNING: Unregistering cset $(basename "${cset}")"
> +			echo 1 > "${cset}"/unregister 2>/dev/null || true

Same here.

> +		fi
> +	done
> +	shopt -u nullglob
> +
> +	udevadm settle
> +
> +	local timeout
> +	timeout=3D0
> +	for cset in /sys/fs/bcache/*-*-*-*-*; do
> +		while [[ -d "${cset}" ]] && (( timeout < 10 )); do
> +			sleep 0.5
> +			(( timeout++ ))
> +		done
> +	done
> +
> +	_bcache_wipe_devs
> +
> +	BCACHE_DEVS=3D()
> +}
>=20
> --=20
> 2.52.0
> =

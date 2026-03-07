Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9B837C921;
	Sat,  7 Mar 2026 10:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772879161; cv=fail; b=mfUST/qn7cYG9A630xna96tRU5K+Q3e8+2F2GFX2H9QH821WKVbL21o7yp9Xx168auwoii/KAi0NYgwK9KLRDNnHqQilRDXB9Kjx6DWUgcmfBHiumxnkR3AJWOVakh0USVU6Yo2lpnfc/hklH38b7vn1kD61Zg9eJLG0aHNFrso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772879161; c=relaxed/simple;
	bh=MBEabptQ6XlBrPfmIloSeav0UETArPjIPjtZ5aTazO0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iHwfxrHh1m4lKDpuIYii8M6prvh8VvhpjCcLgO0yw16kXiLpgfOblIT/+9fNUmimfbBeEH2BLYbzb35Ya8t2KR6of2v+VMYogiHKjQ9I4cR6JoCOaZCKXetvyuejmOUIU57XLrUVvZaJKqxzUskCTwyfBUNCJoFfm7L6mAjnAFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=j04xCRkR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=H3uBw7Ya; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="j04xCRkR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="H3uBw7Ya"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772879158; x=1804415158;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MBEabptQ6XlBrPfmIloSeav0UETArPjIPjtZ5aTazO0=;
  b=j04xCRkRlW0dVbJQ6rVJND6SbdT33t2ly1qi5nKTqWEnG4WtUlBxfcxh
   aXF3cgxvqQKA95Zcb08E1eKfD2+ZDNZjuCQmJsUqTUS3qPRTEdwRzc0Uu
   hMNMJONQLx0lAg0riCczc4JMyK5BRnNhwGT70eGmZBMZ10Bidpb7zta9n
   NK+e1NpPVtuWbYU9SvpqPsCtwQtNQVVKB0uBNCdbVOYqDvjeH+ldIpj30
   QTp4V9jr9qqmYD4yLnRFk3GDu4494kDvosKjBvBEEx0P2wWdVy1P78IfK
   IU0+htVisXfiLlyiXHGaUU9rW+VuH6zKe2CfQyaXYkOb7NA44n7pm3Uk3
   w==;
X-CSE-ConnectionGUID: rM4fzd+bTrencicaoAhzdQ==
X-CSE-MsgGUID: VloviWx5S4m5v6T5pbJMBA==
X-IronPort-AV: E=Sophos;i="6.23,106,1770566400"; 
   d="scan'208";a="142615438"
Received: from mail-northcentralusazon11012041.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.41])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Mar 2026 18:24:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q18gg2Ke9tZ/LeyGUnFZrc7kLG0OVMKZUjFLaxaske+r0GtNTaKUYFbkcBzVi8OHTXhV1g3zQqsP/PGtsZ7prQToFbg5CEvvTcI0jytnU9L8k4DgApxcYbfO2V03VVTEuolmS6CJYU73eZWud+Y/szj16mZeCZYzR3vCmv4dj7pmvC6/YEQtp8HrjggAzpq+4VySM8V1Px5D6EbJatFvbDC9gYG1eEn1592gMeAvz2ybejko2wQCu+20ykHPTsU5wW5W/3gzFsjOiIp7zLHJ+abhLoubCskr57ki/Si3T1GIaSPCgbmBhbf4t4PfEggdIiYtgq03kavcPSjLjnrfoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBEabptQ6XlBrPfmIloSeav0UETArPjIPjtZ5aTazO0=;
 b=OHJRkyNl4t1n0BtyUgMnqduFI33MlMFnA9fooR9ikzWTVKr7bvnZwvbXE3OmptrGtDoNRH0jKH3EYazNQigxl27qOpfZmnmL6n0UuVSiGn3luk4YDYc2MheIAfW0OYmeRpTAyZtcEIqAxs5tsZ1LdUh+5wmT0X1w0LpA2obccRIDcKSH2LthmToSfyHOmxuHAk4PKs9UJxNi71CybyzHTtl2TCBmORVF+78VVqG6+iYWhGkuOe0mwHZBsyjw/PVnCV0lo52zKoJMBgAmAjaRpKwRD+VgDuvp9AH8AsQwul6D6DvNATKEmuFMJvBd6vd2+sRz/uNnzKRNNgH0YlW3bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBEabptQ6XlBrPfmIloSeav0UETArPjIPjtZ5aTazO0=;
 b=H3uBw7YagWQTOXoKy/FVSxX7pNQpk8AA66HNVts25cbYuHAY92B+uVHYlnmlMIYZqNhybchYB4/4eScyUEDwWAjn2nWKvJM/hYKPK1K4X5MtxBjCj5Fgq4+P7yphTcS/zTnOkBOvp1JnQC1ZDNYZ9QuPfuJJjEvlRqwt2Fr/Spg=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by SJ0PR04MB7600.namprd04.prod.outlook.com (2603:10b6:a03:32a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.20; Sat, 7 Mar
 2026 10:24:46 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9678.016; Sat, 7 Mar 2026
 10:24:46 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Daniel Wagner <dwagner@suse.de>
CC: "hch@infradead.org" <hch@infradead.org>, Stephen Zhang
	<starzhangzsd@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, Coly
 Li <colyli@fnnas.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v5 2/3] bcache: add bcache/002
Thread-Topic: [PATCH blktests v5 2/3] bcache: add bcache/002
Thread-Index: AQHcrLEPQwqT05OYDUyRjU2eLOm8z7Whb+eAgAANGgCAAWLZgA==
Date: Sat, 7 Mar 2026 10:24:46 +0000
Message-ID: <aav7vTM7IerMwsT4@shinmob>
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
 <20260305-bcache-v5-2-04cd4c9080d7@suse.de> <aarFVqxrXF9Bah31@shinmob>
 <baa3a723-2f9c-4e10-9d42-b4152de92df2@flourine.local>
In-Reply-To: <baa3a723-2f9c-4e10-9d42-b4152de92df2@flourine.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|SJ0PR04MB7600:EE_
x-ms-office365-filtering-correlation-id: 62b3db58-6864-4bcb-efbe-08de7c33c185
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 FCxB7W0kaTTQFUCAAOru1l/dMiolqEaBm7aOLCG9akaupc3ZhFFGA9us92B7Ouq590jbKFUMZxEuku3ZcYcoWx0r8Z56GDX6/iI5vMZ19LKIzYjncFtM4QgeSHaVFunRPEHmycGX1Eu9THHfia5A/eynl6CdP9JYnsVGRTcYIEVKlViWZ231/nINn7YnkB1yZ6vAXq/Ej8V0Q1xzVgguDIqe7SC3Q+WGbXq2IGg1U2ctGLWmYIhmwXPAmirb505qXp+LqJje7ZbBb8L3MRStN7y+GBYSmDs9MoJSp7vDYMugAlHYQ1IGc0Hu3P7mYWKe4EkQaMqxUXF4zDSNFXZOIv1B5TX4m4Y7mtKwmSwt6xEwVuWkDTyzlHaVmxVCxdcbHyItTpgMKUFpCd8vvt8caX3LHra0f6NNDY56MvN9gJ3XR3vwXxgFa7fJ0k9UkFVePPUj0CngIHi1HouCbfNg630QtTLKAD+yBHZJXjwc/c89rssCGzDRWIxSh5wLfPudMCM1LxoLKKvpeAXdBt4Mp1f8viSMk76VUHrizWflg772G7qFNv2YHkL+a/Fo3c/jDR5WiHMgqF8X8EhxCTqyXwFbIOO2AKRvY+r1o3tRFwUMSIZ0fcLq1whpYKN78ijzOzylOYMQVj0vxfo3v2e0V3jl0QnmhyJODpgkD4GbrUz6lryt9FRbE3/meI717ZHqYucfM57VUFZPpqm3w5CT6a9jd8j/qKPG2Dm1vQHMpma8u3+Vlww59+pih+ecNugqrvtSb4u9XjL8hhqlZpOEcB0FjoY37v+gLY+ElyCl9INl0Hf/oSkD7f+arR8f6XLh
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?AHePuAqM0HdWHGXNqWk3DbPQFQCFl82937NfsKlx1hzD+1d7c2Unj3SzfJg+?=
 =?us-ascii?Q?GxrZFoRLO3WJ9tRZdxWZgGafO7dQK1fL9T02cckF+Ylx0JMTCKnurn9UQU2+?=
 =?us-ascii?Q?OaiCp3WLr2o422HRTgdnlT+3YSVNGIL/8GTBpUixaU1xkpndblw5c86hxz7J?=
 =?us-ascii?Q?UFi/zzKMJZue2335zQP74kwsGV2bm67g4aV5jZNduANlrjtsMRaI7mjsBmGd?=
 =?us-ascii?Q?3cGcHaD+DBJ/ByhEbyCb9GlinZjsOxGjkcbh4MFqy6Zix1/Apm+eU5s5NLbe?=
 =?us-ascii?Q?oYkVhHR04rXD2+gY9TRboC6Fs8T5ioq0ZhrTwqeJpE3rUfmaEod4zFDvUZpE?=
 =?us-ascii?Q?d/MIJeQZCfTO6i5Y008XoRvqb8J4siobn//hGVUE7nFdGMikQRgz9t0TMrRh?=
 =?us-ascii?Q?/79hqeK6ZzEt+38DJpM/IP7ymnCLbQqn+tAoqCLrcD4om2GZODg8DbqrC99S?=
 =?us-ascii?Q?d6qWjBtW4XZwke0NURrz+YL7h1Az4BxMTtwB0A8Z5uoy/7HbvdE8KTE4v7CI?=
 =?us-ascii?Q?hmIdlHQtByAgLlFhW21bTW7Bll8yOdOvJoMYzDW4OHYun4s6dwRIR+40JhyD?=
 =?us-ascii?Q?07mBUZGaEa9QNGtCsG2H6KvigbJwahf1nJH468+X+AIACjYNLCqYt77mbDOL?=
 =?us-ascii?Q?OznedTrr5pGvrScdK+mQC70mbSbWrwQBO5BNA3o3aSNWPzc/fvZjyEND2hdE?=
 =?us-ascii?Q?MpJA+Fyk+u99oSozVxASLZwLOUZyCbOeJLNPbZkFDaGH23HIuQuBuHiz4m7I?=
 =?us-ascii?Q?1rLobu05t1OlcYjy5nCXCdD63eS8U+CbcBJTOfxDhgvfadXAFJFdAhW3wIMW?=
 =?us-ascii?Q?kAphbUq+D0/JuY+Hry9oaEnkeQzpr7+duZPjAeivwch6dMDJY5t4kSq04RSa?=
 =?us-ascii?Q?7zKLEDqXy7EuYml+c8RWaILNPHy5XTuwaOg2DFk/IdL2ryj9T469bKs/sLf1?=
 =?us-ascii?Q?VlW8EEWvjE72oLbEsBUk/x+S0++E7s1Cnc+7/NXnhG04wUW7fW/1hkn3G8wQ?=
 =?us-ascii?Q?us0UK0xwDVY6jZaj+FzE8O1lFMelJ3ohKh2rNLOeE+h/mOqqAzYRjTZXwvRD?=
 =?us-ascii?Q?gKV/3UvvbmiCfntxRxZVrUkXIVJ2X/H97NNO7nx+3Fz8rgi6PlL94caNV1qE?=
 =?us-ascii?Q?VKgwTHbRGV4gwHhkOPSSGNYI2ngSC3t8A9ghHcIXggjv+4UaquEiwNfAgp23?=
 =?us-ascii?Q?0/rsZfPnZCeqNr09oMCY7z3WaLPUp29qWHENky/plAe0RCHW3kLl25GsU5BK?=
 =?us-ascii?Q?JflUFmJH55S5XKwmRhVdo8/p0p0ot4LdokaKGToQWlb/Qfelf7BMgfw+Uyis?=
 =?us-ascii?Q?ncQ1Q8vIOIE3pjZdFTuSo3tPfVfFi4okiKgRynMpydmuWHrFEQY4SR6hwdMH?=
 =?us-ascii?Q?p16llZSsDcIQu1hVAS7/57Wy27d2GLWNqvqp7MoEc88ZFxRrEBaoSWJXRuky?=
 =?us-ascii?Q?Xn4ID0rfaoeH8pxQg7AeGjVBg37Et5w8tLLalxFLYpXTFY1oNtHgqT0MQxn1?=
 =?us-ascii?Q?JKLghJ55rSZZFP87Fej8e5u3/kCWUbfk+Eq4G5WLVJdAQ2FXkXS1N1jjSzM5?=
 =?us-ascii?Q?JZ5NQgcALbrH3Q2jQ921shhxQCYiglnWBkUCkKLqafgyz3h/crTPMfe0qLCo?=
 =?us-ascii?Q?zQckEDXKauKEoifFwTGSBJbXBtV916ZvXkue7qmOwhSTvwpoYz8y3TpgElnj?=
 =?us-ascii?Q?KUWEX6QhFWdudzbODNRJaGOBsj/PU2EozrTs/QrHHqdD67Jfuypju8nl8NYG?=
 =?us-ascii?Q?jaGVgR0NPpIbt2GzvTPWOOc3ZETgqEw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15EBD8D63959A849AB91EE5D3D2AA7F3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	ko8UZSy1C3x4mhvDE3GwG3BRV28rpndPNLQUPHgDcSwhlrsjCwB0J3saTLDneAS9TvtWVSYeQn90pbK3ji1mnIPVMH9AJE9kZE7+d66v4UPcypAN59nuDW9Ah7zbJkb7pstOKbc3DrVOHt+EhRD1pXms0JDDdQYuz1SL94gUMsHUCdjrYxMdNe/vzv/xXRCpA358gicjHBXKA/tnDR5KqKhGCgeuzM+Cr3in0jOyf4xc5mQMJGy8iB2buEGU4kD/M0MrfZbP8f0rBWJimCKephxu6SJ5bHxvWvnFEj6lH6hbcaLSrXs/k3SxW2bITd/xV19Mgx5FPcNHj6XLnjvcxA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+ZBthKRG49oq7EKo+WMgtyOgydQ3som6bHv4jB3Hciw8iPdugnjIA3bvf7cLoZpylVql3vbjX8Hb1d300/Icb9q2MyezRJU2Pg3DNTRFJzebSIIPJzf0n2jaQsm6ad1R/BlpecZp8BYM1V4mD/Twvfo90ilBgjaKRpfozv/zptOUdcx5GWkdJ0DcrGmlpC7XI8SNkVHbKCapbRzhDnd2Q50s+zMWPtj4tAAf7+eyh5XowW0dD8/e4h9Dk3v+cf09MXWnq2g//mtHp3vp1MHNeHPuzEJgiIEfh3/s5uKCAync2hn9M0zotUBcMo4aEWozqhQ+YsqMm23PMjylnWvrban5JrYBEmdB2RVtoiyKGq+DivT5a6fZQZCitTm0jSut5RhpigQKhSq0dCF++7LLk/B1dhPalKuG43A5Sg4VITI+DSwRayc5izIjTlT7J3pFWQjsxoamGa1Ta3YjsT1WMCuTYOelzyow6KMVQZba1ky7gQJuRS+51a6hB3PPJ/nUxbYcM1Qv8IHE/7FYNrhXNCK9FGY7F5EK8dzTy4jBe8WBOjfdE3PaWpuLdEsiap0m5xzzHgzTC6LyUYvh/c/nS+x25UE0O5V9aj95nP2Sp02Mpj1gPTRAmzADRUvw4DHC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b3db58-6864-4bcb-efbe-08de7c33c185
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2026 10:24:46.4600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkvRKQBu1rGnLSRq5j4VkZA1XZDSTI2fVwM+tP/EOHRKcyaOAccx0aLjGTue1oXJdff8tdMpQxEyznG+6DqZl2nTnrOdnzOno/54FR7yeso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7600

On Mar 06, 2026 / 14:14, Daniel Wagner wrote:
> On Fri, Mar 06, 2026 at 12:27:51PM +0000, Shinichiro Kawasaki wrote:
> > On Mar 05, 2026 / 16:01, Daniel Wagner wrote:
> > > Add test case from Stephen Zhang [1][2], which is
> > >=20
> > > 1. Wait for fio to complete (wait $fio_pid)
> > > 2. Wait a few seconds for I/O to drain
> > > 3. Then check the utilization
> > >=20
> > > If utilization is still > 0% after I/O completes, then there's a real
> > > accounting leak.
> > >=20
> > > [1] https://lore.kernel.org/linux-bcache/CANubcdX7eNbH_bo4-f94DUbdiEb=
t04Vxy1MPyhm+CZyXB01FuQ@mail.gmail.com/
> > > [2] https://lore.kernel.org/all/CANubcdU92Uv7wNdZH357LLTnfwPouekXNTPS=
jHnzYzK99-eZ9w@mail.gmail.com
> >=20
> > Thanks for the updates. It's good that we do not need iostat :)
> >=20
> > I ran this test case with v7.0-rc2 kernel, and it passes. Good.
> >=20
> > I also ran this test case with older kernel without the kernel fix [1].=
 I
> > expected failure, but it passed. I ran the Stephen's original test scri=
pt and it
> > did not fail either. So I guess my test environment does not fulfill th=
e
> > conditions to recreate the failure. Daniel, did you observe this test c=
ase
> > failed with any older kernel?
>=20
> Same here, it doesn't fail on older kernels either. Maybe we should just
> not merge this test then? Maybe Stephen can have a look and figure out
> what needs to be done to trigger the condition more reliable.

I see. Before merging this patch, I would like to make sure that this test =
case
is valuable, and it does not just waste time and power of CI systems.

Stephen,

May I ask you to share what kind of devices you used to recreate the failur=
e?
Also, could you share the kernel .config to recreate the failure? I would l=
ike
use them to recreate the failure on my test system.

>=20
> > Let me leave nit comments in line. If this patch does not respin, I can=
 fold in
> > the changes for the nit comments.
>=20
> Sure, just fix it up if you decide to apply it.

Got it, thanks.=

Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE29039E6D4;
	Wed, 21 Jan 2026 08:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768983559; cv=fail; b=mKFYlzkirwaQ8iVi6S0C5tKNbbHkxZkrFpZrAFJ4qL+XdtuiY7ZpFhu+52spJnaIWF3dB7qw9yHgimVXulp5gHOvm6eFuLn3RthJlXymCigFONqkxri828bTPjtfnptzjF518WV3jCkW/my5zthkfrCc9gYecyNGDIAmHhWfdxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768983559; c=relaxed/simple;
	bh=DFAUX9pkCv6vwp9ZqJceaa2CSH2y8GcDntkwRScdhsU=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d9TyoJjCaDrX5JtqKROkW9KiyLRWSs6QlohC/dub6XcYS/siavk5ArpGnWgH9rGe8lnG7ucTCOeTEx4dtjEIk8od1aRo6bGLsKP7uaJFarR5X2+sSYPrBjblzHRQqj7YyCYA8EKUJZF/Z2L5Odn11roKFLrTk24rMk2gmWGzTGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GcXcmvC7; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ArEecm7a; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GcXcmvC7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ArEecm7a"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1768983557; x=1800519557;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=DFAUX9pkCv6vwp9ZqJceaa2CSH2y8GcDntkwRScdhsU=;
  b=GcXcmvC7QsPDPxaq2llY5nYiqMUeDSFZTuzDsg/eKmpq9Bi0rWshm0hd
   9QK+VEbYmTFTtjpxWPvkE9k6IMyLG5oeX8mnHkyVZ5y6nQHtzp8DuPQXq
   nDIHhHDmm4I08AL+4B2jb7L94Z2Km16usLD1F7R9ru2R3O5szZ5zjxWaM
   DsHgTHpPlacnC8tHZuQWhQToucrOADJHjVLkaqAzTM9fM5p4+JacSb5yc
   siT5P/IuJNvwJfNM2bWM3U7hCD0zbKadfFUWN9tm33nB13vDM6Oi41RXA
   Mrq4RUMdUg/8bY+TX7Sa1Db8SGt2qR6EpRY43KKuMr0e4RaOC7tb7+G7H
   g==;
X-CSE-ConnectionGUID: 5cFmwiLpSCe3OrRV2nmmEQ==
X-CSE-MsgGUID: QRuit+YESHSKvvN92UXNGw==
X-IronPort-AV: E=Sophos;i="6.21,242,1763395200"; 
   d="scan'208";a="138443477"
Received: from mail-westus3azon11011037.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.37])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jan 2026 16:19:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M20ySyqBGXpjQlQpYt2JO3Z/ydTfbXfA0Nw1+KRNEFgW86iIfX52ofgqSEK8uGYCtLo4fAk51Q3T0EjMOBh42p5TrI4MsnEK8MysETsK7dVUMOEJzn/UQy0AY9BbuCZvel9YKomia4wvW901JQMpZaA1xo2t2eI30VJy9F2s5YfcukU2PIcr2tS89KjKYNUUNYD6JfvIXq50M0ZnwWXiRSnwZBNheMupCu2e5RE2PYXllF1GKsV+6GE2V005mdzKIXSs5xa7tyQGZfaA+yB6nPOZBigULuzdMiKAqAbov/WzzKUYbfOzV1WGLl9cWaw6/y1C2vgmvjHg5xgJLN40vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFAUX9pkCv6vwp9ZqJceaa2CSH2y8GcDntkwRScdhsU=;
 b=niZ6F0lHBZ0yMGSkAnqyAvTd77bLKTLptcMQvHYoyVIOdt3312mCsWAriEvpicgP+P+J9iZjceRx5rrtW04hak7nbwSgMphNtwNnonYeKYOrIvzcjHjO08LUHNOLU+syMSwcAPey8UuvK+8ad1Y6wyLY3LP0MKSuEOiOOSakbNPo3HZsd9znciunOO1tx1XoraRbXdezZlVTrg08hoiZwWUNuLGXb1DSKIqJR4NLvjTuTHp5Al96Z+i8MpoIOVyDaAKfunnysv+0F8UonorhcZzg6RUnp1sVZZNM0d6/Ewtunu60kfvl2E2589TbaADcBg4HSEEdUzOtOJjSybPZtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFAUX9pkCv6vwp9ZqJceaa2CSH2y8GcDntkwRScdhsU=;
 b=ArEecm7aFc278hDPjKYPN0l5m0kpLx4Q8K+pT0Z4mXOfB2yh+34vxH1zZMKJ+vqx/8s7VTGWzgNzlOJVzQgl3H1e4+XrkhZKtDZtcNNbAx8kbg/r88LN4e/a7ES/U2T9IcnVNooc3jn8r7ToY1tGWYrNr70NXvZ7YoamoOK73Hs=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by BN8PR04MB6289.namprd04.prod.outlook.com (2603:10b6:408:d9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.3; Wed, 21 Jan
 2026 08:19:08 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8%5]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 08:19:08 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Daniel Wagner <dwagner@suse.de>, "hch@infradead.org" <hch@infradead.org>,
	Stephen Zhang <starzhangzsd@gmail.com>, Kent Overstreet
	<kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>, Shinichiro Kawasaki
	<shinichiro.kawasaki@wdc.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org"
	<linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests] bcache: add bcache/001
Thread-Topic: [PATCH blktests] bcache: add bcache/001
Thread-Index: AQHcihVG6D1X4e2kIEC6T8T9tPy7QLVcSQ6A
Date: Wed, 21 Jan 2026 08:19:08 +0000
Message-ID: <bc45323c-d261-4ff4-8174-28fbb0676237@wdc.com>
References: <20260120-bcache-v1-1-59bf0b2d4140@suse.de>
In-Reply-To: <20260120-bcache-v1-1-59bf0b2d4140@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|BN8PR04MB6289:EE_
x-ms-office365-filtering-correlation-id: 661124ee-5b28-43f4-b3d9-08de58c5bfd3
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|19092799006|10070799003|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VzhScnZtZmxZaGZKSXJoMWtVVGlkNUt3bW5QNDFlZEtDQ20vbU1lWTRlOUFL?=
 =?utf-8?B?QWR4ajNEZS9FMDV3bDA5WFRRN0dOTGxoT0R1QytyUHdTY2ZYOEdRR0M0NVAr?=
 =?utf-8?B?enU1T1h5N2dFVkRmbVpQUFN3eW1QZU8rVFkzeW1RNksrRFQzRTRBVXZTZ21r?=
 =?utf-8?B?OVNKYXlaSWJnbUtSZnM2WlpxRU5sUmx6eWtBSWJyMGZzT25MWGRjOGZ3YUZp?=
 =?utf-8?B?bXg3VkhUbnlUL0FiZFJ0RG1mYUJkR0dpMmovcVJHdGdNWXRGKzVmY0Ztb21q?=
 =?utf-8?B?L1ZzMEVONGVTencrUmNWNVdpb2FYMVEzQ1lTK0ZLc2o5M21qN1FDbEJka1R3?=
 =?utf-8?B?UlFxbG1FOEFoaEx5WlJIYkpTR3JDRkdENkYvMWpoOUsyVzE0MFVDanFDYlZo?=
 =?utf-8?B?Y2JobWErMFlmajUrL0JhSVZ6aDU5cVdha1JNSkh3clhLVWM5Nnc0ZzJPanJ0?=
 =?utf-8?B?RTN4K01FQUt6am5pZ2xEb2xEdTZWTjArbXZ3OS9uejIwVndydjRuSW0wMnlx?=
 =?utf-8?B?Q3lJRUlYcUtLN3B4a2hlNTUwVUhnUnhiSll0QXIzeFJoT2JhSHRYYkF3WGRs?=
 =?utf-8?B?dVo0amtJc0FndDQxa3QwSnlwanp5L3dsa0pVeVlEZDZJSEw3RHR2SGpuOVRJ?=
 =?utf-8?B?dU9oeFlUTi82M2N1VzV0SWlmVm5wc0tYa2ZmbTJia1FYZHJ3YmlhWndTc3V2?=
 =?utf-8?B?TDZTdlVYWUpsV0hhY3BQVXZyNytOeG0vQXh2TzE0QlVsbXNpNzdXYWd3Y1Qx?=
 =?utf-8?B?eTBYeWRtMDFRZmlLTkFVSHF6QlgxM0ltMmk0eFhFcGxDdlZlcnZmeGo1eXRT?=
 =?utf-8?B?VER3S3dJcFlqK0JXOVZhVDZNaElrNzV6MEFTTi9DczcvQlA3eHkwU0ROWnlD?=
 =?utf-8?B?SFdkTGJzV0g1aDRxSitteGF0SjJLVHVEWitVMVJVNGpyM3pCTnFmMGhBTDRn?=
 =?utf-8?B?eUhTdDNzT1F2Qm9tbmtkcUZJT3p3VUM5VTJXMHVaTVhrWWNLZUVyR2k4UkNE?=
 =?utf-8?B?eTFqMmxrelV4SmJSb2MwRmNQUjVsREpUOGNrS2xLY0graU83VlFzZENFTEYv?=
 =?utf-8?B?MVg1OFRjbmdiWFZ2T2I1VjBmQlRBQWR6VjVsZnh1SVpSZ0pYT2NUaVQ4ODZU?=
 =?utf-8?B?ZUJtbWYwbm9lM25Gc25FQ2YvbUpTSkFuS0ZYVVAxbVBEdjRLcFVsM01XTU9F?=
 =?utf-8?B?K0ZpLzJPOS9ZM3g1bVh3TWhEKzJWRTZEaThzNGdNdDZxZHN1S2pESlBnakxz?=
 =?utf-8?B?c052eHNaYitLMDFuTkVVd25iOExXN1lZek5HbUZmcXUvak5yWERQNkt5dEI5?=
 =?utf-8?B?NmpjM3pNbmY3aDhKbCtVMDQzd29GWWVaQTFiVGsyekZsRWFPZVRCTWI3MGxa?=
 =?utf-8?B?QWxsVDJEdnlLTFNhZzdQSHF5OEwvR0xFQ1IwTFIrNXZST0VBbklIRmwweHMw?=
 =?utf-8?B?SklQbEZRdCsvekZQN3U0dUxEczMvRkx0MEY2dE5iY1FGcGtiRmttWDF1eVhV?=
 =?utf-8?B?K1hRSHdoNWNXa3RMN2VJK0RCT2RBSENBUWlZdnVYc1B3Rzh0Q1d2eHBFbVFC?=
 =?utf-8?B?dGNUdlpNcEpPeGJPODhKZ1lOT2IzOWh2dklMS1JQS1RBS0dCZjVaODN2YmtD?=
 =?utf-8?B?b20zeDFXSkx0WjVtdkVqTkdjVmdJUU1takprSHdxU0ZmdzRqcGczYkxUa3B1?=
 =?utf-8?B?djRkeUlHdVBOVDlYNTE0cThUcGZaQWFoQzVKZlpqZUNPcDRWTUU2VmpHMXNz?=
 =?utf-8?B?cjFKSkRlWGZQT2lPZjVGRFJ3V084aHFZeTAyNlpIdmhNV2xCa3h0K1RsWXEy?=
 =?utf-8?B?cWJoV1ROcFpZRUtyS2d2cGVXeGhkWGlGTUpzaDY5UFdiN3Jva3VsQ2YxejZW?=
 =?utf-8?B?TlhiV0VuaXJBVHV4OVBQeEVGN2hNNTFINndqL1RhNnJHYlN4VlpDS0Q4NG1h?=
 =?utf-8?B?QXNUdER4QkxSQ1o1UlAxK04wNndQcXRCQUFxSlFxVGFDdnFtQkxPU1RyMjFs?=
 =?utf-8?B?NXFHdGhJREdneU1JWFBmRGYyamZqYXRDT2xKNHFQZHE2WUlrc1dESWpNcS9U?=
 =?utf-8?B?Mmk3SnJUL2hTQmVadHI1Vml5Ym15ZHB1am5nR0ZyaEhOQkVNTE5WYm1sS1Vj?=
 =?utf-8?B?MnYzQTJ0bGEzNFR4Z1hNYXFMckNrYjBORVdPMEtnUDg3NmxxTFZyVXhjVmJZ?=
 =?utf-8?Q?tf/c9zdsPUIWVI/KhLAQxgk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(10070799003)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MGJTT2FvaEVXMUpKcHgydkF3ckNjdEZqS3VXMjA4TnhtdzRnZWNZYXNXeGpr?=
 =?utf-8?B?VjVmV3pqUGkwMHk5ZW11VVZreGZBOWI4Y1FSVEFNdlpyQjA5ODhhSFR4M3o1?=
 =?utf-8?B?SWFURlJtM0ovSjFmTThYc2plcG9oRTh2MExOai9ZdEZScTlpUndiM3RLcHA0?=
 =?utf-8?B?V2xlb2pTemVLZW50c1EzRDFFY3FxSklkSFAwYkNoVUlzeTN4b0Q2bFNvYXlU?=
 =?utf-8?B?TUluUGdFL1ZtWWExSERxTlBpNTNRZXJqc092RGI0RGtlMlNRVnpFY2dCb1Rw?=
 =?utf-8?B?dHZxZXE1MmltNllTZmxkdmxmaFNhVUtLQnhuMHRONGhrVG4vTDVPbGVuaW5y?=
 =?utf-8?B?K3NjMUIvaHhYRFljWmF1eUhQQlNTdjU3L0hQVlNuYnprV210dnRzOGlvcm5U?=
 =?utf-8?B?NTh3elpGcTJCUTMwNHp6dkhwRjcwUkNwME1FTzk5M2VZZENyRlo4QTlUQ3U0?=
 =?utf-8?B?SlNTYTVJR0NxZnRSMXhYdFF4NURDMWhST0M4ZTRuYjNkbWpxVDNZMEZxU216?=
 =?utf-8?B?VlJxQWxmRXMxUVRmdU5PSGxRQWZMYzQ1NFhQN2VEZk9VNVdtUlg3ajlsanYy?=
 =?utf-8?B?dnE1M0svSm5zbTg0aHByL0orSkNyMXlOUnFwVWkzNTRWVGhLbmIvcE5XVlVM?=
 =?utf-8?B?ZkwzYTBGeTVXNncvc3RURUpYMnRlNElUUEZPS2tQRHhrRHJpWXo5Tys0L3hI?=
 =?utf-8?B?Mitrd21XMTVKaWwrOFNVK3lRSVJNVWNlY01FYm5ST29kVGlLRitNeFhrV0RV?=
 =?utf-8?B?OUF3NE5selJUbkpsQXVzZmIzTWZKczhwWEdjLy9sMWF3Q2JKOFQvTGswa0t1?=
 =?utf-8?B?NDMvRFFqMzM5Y0ZLQ0JWWXY0R0NPY254djljLy83QXFVS0swOWhxQXM2cmtl?=
 =?utf-8?B?Ymp0VjRqNXlkMjIrWGkveGVpRkYwNE52VDhBTjMzMm9ZYngveHduRVZEYXFT?=
 =?utf-8?B?c2xGdmx2ZGR6V3hDUFVyczRjUUN1UHRNV01vNkpVSGx3VnByQW1EdktKdEE2?=
 =?utf-8?B?cjVTT1YxL2ZnZWRPY2ZHd3NaanowNS9LcGxjR05FdDd3MFQxb2tYUStWZm9j?=
 =?utf-8?B?SWMydlBkRGhSNU1oTGovYWdSSWgrUzM0eEZ2bXloRXdzb05JZmxkcmd6anRL?=
 =?utf-8?B?NVJiTy8ydy9sWnBsNWZrWm1GWlJXSGZPdTNsQ1lsVzd3SnhTUkdWRCtmaUZX?=
 =?utf-8?B?RkQ5TzdvN3V4QmltOE91bWlmMVdqYnRQaXFkeUxvZTFlbDdFbjBhTHNRY3VN?=
 =?utf-8?B?UldYWmw0SmNHUWlXOE11MDlnRFdxcURBQ2paZ0lEYjhRUi9zSzRKd3NpTnov?=
 =?utf-8?B?dUFuT0VJcXNoZnFaT1JOcEdXWXl6aTNLVnI3Q3cvNi9GWFhxYVplbUFtTFZw?=
 =?utf-8?B?VklJWk9YKzhVUUFCditSNGlscXR0S01haC9TR2hUYi9idXk3RjI1SUZFbytl?=
 =?utf-8?B?UnI1QXczWXBsaTVlMVRJeXYyZ2FjYkZSdTN5NlVRemRMdHpIOEZ2Z1UzZFNP?=
 =?utf-8?B?TjZVQ2piTkF6c0JDL0c2OFlWdldpNWk5KzVmWm1MUEt6RHNXaHBwbGF3ZkZQ?=
 =?utf-8?B?Q3ArdE1iWm1uQTBzc3p4enhVU0dSOWlKTVJaaDJRNm5WUUlVbmU1cXBUYXBF?=
 =?utf-8?B?Mm9Lc2lRS3JQVXpUNUtURkhhME5hOWNIOGl4eXRkZndpSTIrR0dlRjZBcDNC?=
 =?utf-8?B?YTRKalJmNkZhQTdGekN3SXM2SlMwUCtBaC9vNUo4SzIxb2crQjhJUzNaV2h2?=
 =?utf-8?B?RmFiRkJoZzZjY0lGVU5lU1RKSURrUjkyZkhoODQrTEM1dXo1dU4vR29NS0Zu?=
 =?utf-8?B?RzNQN09qdkJCdVp4ZDZFTWMweGhkYVdRZlJHVk11azBDNkt0MVhxWVg5T09p?=
 =?utf-8?B?TEVDaExNQUg0NndGZWlEaEZqdGFSWSsrWUd2NVprekthUW5hM1RpM1pBWXd4?=
 =?utf-8?B?N0oyWDlONUt6OXV1WGxRdkRrUTRNanIwQUs2OFpMb3JNa1krVE9HU2RTaW8z?=
 =?utf-8?B?UTdxdUVBSkJkd3h2V0NEL2crMzJLaytoQ0kyY2x5eGtPZ2U3Wk1MQTFhNzRS?=
 =?utf-8?B?NHJRYTVyWXk0QTIvRkpGZ25BODBoNENkNCtidlZUdlF4WUlzVUlSd25icnVN?=
 =?utf-8?B?cmlVbUtURkxxaEwrSXZPY3R3SzhvdFB6bXgrc2pWRE1vdzJaQUllcWJhRE5D?=
 =?utf-8?B?MGtkTWhJV1BmVlpydDV2akVaUkZDdnlMNUsvaHRMZURxbFdvN1NyZmVuZXg3?=
 =?utf-8?B?M09QK3gzNG52RzlhVnYwcGRrQ2pVN2pYR1hOZTlHMVUvRXlhck5sZGZSbC9P?=
 =?utf-8?B?elpnZUhZTHdHQXhhcEdxcnNBalJIUzFGcWMxbFA5K240QjR4TjVaY0d1L1BO?=
 =?utf-8?Q?4tOAeVsF2BvULMHf631QvkTbKVyiZNvw3FSGq16JCpzGi?=
x-ms-exchange-antispam-messagedata-1: pvR2z6ITeV5OJ0tPGWmIxHVJfNbJiQXYwxo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C669A22A7291324096CE249050219C54@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n0DxTP9qAIhGXq0zFTiRqZeBPiyxruxTKyDHQWtvGpzINtPgFI+LEz57v/zmfTCGvMQce7TXZ3JPdhnREYiYp/EJnaEOJtMA2+9MwSVXB/2jgDYSXqVkcCw57yoTtLbtOT6ZwGjVoVTax7x47cwb6LtVWrKUJd5obRGRzyd2heBDpAfcYolo6aOk4j3vYzNfTE3D8L6cdMtgGIL+kXZ1Scu7/kIhTxk1VRHYreMR6T/uTZ6kd8xcSKVIqRxi8lWqg16qd9TanI0I/Mx0eusWWTGpKRTa6ilOFL39l8rD7xJU4KbiFx7TYV6TMSok4lOl3vwUdcWWzLLB/34CGquMSqFtre+b/ZaIgame61wgOr5oGh3EMHuYemlv2hN3D5X8r2r9YVRs5bqYQ1EBl8cCFi0ymc0xKX+jYB+JvURj1pBE7UhAzZtvZFdxrOkVn0Sq3UzakCTNOSJje9N4OBhdywJz0Ga8xFCeePZSkYOlgwv5CmerwYglG3xxO9vR2Sm+MxJ5XPlEfnl8tpHw+RxVaSQnD1g45MWvyG7S0HTEfvjebs6lygX5sMUREBBZ/TnphJh911PA73jEm5Xr1w6Dm9kBVd5fV9hhdT2G4UGcXEgK4MVatdqJaPzE6qvPBA/r
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 661124ee-5b28-43f4-b3d9-08de58c5bfd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 08:19:08.2853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CPIgiWAN6LYTZjbDyeF4NVyJdAPA511d+uVK7kD3j73fW+KwTtobghjkOMLOWv0i9ySh0GU0f/6GUA8pAatrQ3CgZYXzwjSkIqYkGxmy98k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6289

T24gMS8yMC8yNiAzOjAxIFBNLCBEYW5pZWwgV2FnbmVyIHdyb3RlOg0KPiArDQo+ICtfY2xlYW51
cF9iY2FjaGUoKSB7DQo+ICsgICAgbG9jYWwgY3NldCBkZXYNCj4gKw0KPiArCXNob3B0IC1zIG51
bGxnbG9iDQo+ICsgICAgZm9yIGRldiBpbiAvc3lzL2Jsb2NrL2JjYWNoZSogOyBkbw0KPiArICAg
ICAgICBbIC1lICIke2Rldn0iIF0gfHwgY29udGludWUNCj4gKw0KPiArICAgICAgICBkZXY9JChi
YXNlbmFtZSAiJHtkZXZ9IikNCj4gKyAgICAgICAgZWNobyAiV0FSTklORzogYmNhY2hlIGRldmlj
ZSAke2Rldn0gZm91bmQiDQo+ICsNCj4gKyAgICAgICAgaWYgW1sgLWYvc3lzL2Jsb2NrLyIke2Rl
dn0iL2JjYWNoZS9zdG9wIF1dOyB0aGVuDQo+ICsgICAgICAgICAgICBlY2hvIDEgPi9zeXMvYmxv
Y2svIiR7ZGV2fSIvYmNhY2hlL3N0b3AgMj4vZGV2L251bGwgfHwgdHJ1ZQ0KPiArICAgICAgICBm
aQ0KPiArICAgIGRvbmUNCj4gKw0KPiArCWZvciBjc2V0IGluL3N5cy9mcy9iY2FjaGUvKi0qLSot
Ki0qOyBkbw0KPiArICAgICAgICBpZiBbWyAtZCAiJHtjc2V0fSIgXV07IHRoZW4NCj4gKwkJCWVj
aG8gIldBUk5JTkc6IFVucmVnaXN0ZXJpbmcgY3NldCAkKGJhc2VuYW1lICIke2NzZXR9IikiDQo+
ICsgICAgICAgICAgICBlY2hvIDEgPiAiJHtjc2V0fSIvdW5yZWdpc3RlciAyPi9kZXYvbnVsbCB8
fCB0cnVlDQo+ICsgICAgICAgIGZpDQo+ICsgICAgZG9uZQ0KPiArICAgIHNob3B0IC11IG51bGxn
bG9iDQoNCkl0J3MgZWl0aGVyIG15IE1VQSBvciB0aGVyZSdzIHNvbWUgbWl4IG9mIHNwYWNlIGFu
ZCB0YWJzIGhlcmUuDQoNCg==

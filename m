Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473711A6832;
	Thu, 12 Mar 2026 01:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773279872; cv=fail; b=uuyFxDpM0uB1Cc4vkj+ca6wvRwjw/U30Yspf/o+80N020wZCp+fpB8nMcEN53YCP1V3RBubwsG5O4a5bokFzBba7CO+nAhzSYD+/lbfg7maQwU+tonIK9qkHh9hIexjhCh4BOHhbmnIpvgYReaReLyXBSJTtbyOGBN0mxV0fLDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773279872; c=relaxed/simple;
	bh=SO1uW1cYBkRnN3Fva+YJYT3oIYNFEdZKy6YR+4R6FPY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t/lQ7668CGXwdc99gvmutr2HR0Jko4VapvxS0Cye/SHVkIgwuMgJ83l0Cybtg5mhvY9QukhKtFRoPEO5QgX+06BOpMLgOCc5DbgTuoBU7Tf17tO1TXSsl0RokAlfnPV4RQcBf0xvJu0Y1bPwEcbo/2lEIjWoKR4KFMgJswRTVms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jZrsRlxS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=v5lA0br+; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jZrsRlxS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="v5lA0br+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773279871; x=1804815871;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SO1uW1cYBkRnN3Fva+YJYT3oIYNFEdZKy6YR+4R6FPY=;
  b=jZrsRlxSxR7tz/qGMNTjYgoMt3Pa6E1QemK6gsVtpS498S60TqKtdhoW
   WhsQFDr/CtDEoXTAL2CQCToTWByuD61rdwju+yPH5FdPgeWUs6x/PCeFT
   K68unX3/CSi3XNqMd+CfiwVPcmS27NS7Qk8XduBdzUlOc8L4yosXhNoQy
   nhGTmpn/davnUEU++a+KGUBC2gLIBAUlZw7DTj5fCl/xCK6uz3empuj0s
   SWC67j0rLoiUMPBphJhFhOdzz606DEmsBMDwdweHJnSz/EAhtiT4Qjurv
   /QT7vuEaHFlcdrRlEduNwUJj1nOXJt0h9d7qXUZRtqXgWTNqFbO9vY4ra
   A==;
X-CSE-ConnectionGUID: mLfgRHSuQMeez33AZF0VMQ==
X-CSE-MsgGUID: AsUDnlJPRGadkt7t5rMNyg==
X-IronPort-AV: E=Sophos;i="6.23,115,1770566400"; 
   d="scan'208";a="142367035"
Received: from mail-westus2azon11012047.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.47])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Mar 2026 09:44:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zMqHQ6bDYnWJzghznyBIAYJtmT7XsnMdmXVcrSoFLuZAJK82R+50+5NUW4DlLOp7sGkSlLfYMykwuWHKs3YpFHrNeLFd7+7G1v/FgSkisT868d9VOPxqnHyd33RWCvx+GoWwxCXqm8ZyNnzkB8WnLAYg76Y6K8fnDNR8qQhigsALYnZF+tkoN/1iIRMe6KwXWn2JR2spI361//r3hoczxuPyShANNB7iGTnDCUqCrnhy6ppKSbyv0BIjnjyzqmq+vzwU+cbe+87RyepXCpe9Xy4XZupwcbL7r8FiE/Tgu9Klx53rqErrbtxLdLeIz9aoToWmwhendnKs52UAVgEIdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SO1uW1cYBkRnN3Fva+YJYT3oIYNFEdZKy6YR+4R6FPY=;
 b=ysv63/xhK2ebFgTnLKdWcQYC+HzI0979MAWbEAZjnqIuHLwKZFEjR9lJvqSehEgbvhzYPMSuB8jZhbsBeYEPimr9ACf1Rs4FqYj5obNiNPYnK2LiMrGV2Td4+iSIv9NyL/isAaU3fm4JYFUZTnrx3QX4hyUPUmi5O7KH39Hvq+0yhvz95JFRQDoH6mzP48CHAPnxvR2edv+aigtl68KPeBq0WpXIY9MsRdlJNWFTdJdF94pCclhbuvjso/NdgxpsJP98w30UER3+c3sISWfotP4du9CjMGPMeS7OKHfLR2f3x8OReEQBTuZ6v2ZwUJZrBPRgMs05xdkJ0q3jWAafUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SO1uW1cYBkRnN3Fva+YJYT3oIYNFEdZKy6YR+4R6FPY=;
 b=v5lA0br+f435VgbXGEr5K6W5vhE3omRQR4/41SNSrm6acnajgHDyuKUG56gVnCm1/8CgGGzTfnrAy6bajC5fsG4xipy4zxBdlz4YZ+o1t+ZmS6JSlBmlJnCcGOmNdKMGcbmjvasF2GrhxVfAMYGmpSAWameITipkDXHmDvXY5d4=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by BY1PR04MB9564.namprd04.prod.outlook.com (2603:10b6:a03:5b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Thu, 12 Mar
 2026 01:44:22 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 01:44:22 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Stephen Zhang <starzhangzsd@gmail.com>
CC: Daniel Wagner <dwagner@suse.de>, "hch@infradead.org" <hch@infradead.org>,
	Kent Overstreet <kent.overstreet@linux.dev>, Coly Li <colyli@fnnas.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH blktests v5 2/3] bcache: add bcache/002
Thread-Topic: [PATCH blktests v5 2/3] bcache: add bcache/002
Thread-Index: AQHcrLEPQwqT05OYDUyRjU2eLOm8z7Whb+eAgAANGgCAAWLZgIAEp60AgAKilYA=
Date: Thu, 12 Mar 2026 01:44:22 +0000
Message-ID: <abIX7n_ygun4zq6I@shinmob>
References: <20260305-bcache-v5-0-04cd4c9080d7@suse.de>
 <20260305-bcache-v5-2-04cd4c9080d7@suse.de> <aarFVqxrXF9Bah31@shinmob>
 <baa3a723-2f9c-4e10-9d42-b4152de92df2@flourine.local>
 <aav7vTM7IerMwsT4@shinmob>
 <CANubcdVc-cP4dAZs_mkTG3rYVYa5Z2ihd3Crp2J-GRDUYpGGhg@mail.gmail.com>
In-Reply-To:
 <CANubcdVc-cP4dAZs_mkTG3rYVYa5Z2ihd3Crp2J-GRDUYpGGhg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|BY1PR04MB9564:EE_
x-ms-office365-filtering-correlation-id: 821525ef-8d92-4732-e612-08de7fd8e2d6
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|14052099004|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 flMT1KSMSE1T4c1eZw+Os6hKpDmhoyOb1h7Q4LvITRSqaXb+aqvtQUsXFQyKfP/FxCLDtSaTPeBTL9/ePuliBqR3vKFxLZowy1HIfpXnQHyV6bqLs+X2VGLnftqLQodC1OgTwOuAw1VzR/mM2nevh6+6FDX8C0JnJ0DYrmV7ni7NpG2yXdY6Nv1D4ZPXT7WC3MM1fF0fVKu0jsmFloueJvLU+CiERoRUPZKeapAm5jAJ8uHitWGf9T6Nxi16T0XH/CKgvJwNb7WPTiTjQ0yWQYCelsg7uQX2VN9UZvh1nUf4K6Lg1s36OAaP1b7GnTBNna975bSdg3pIXVSpmsnQXoMD6Ei60lIzn/kK4Tcr6IQfZgPHOu5dPYCByxZpQfae1bZVgd1hTBBYsD3owL/uGDi3OytkLaMy7mBdFc34ZuYGi5qQ8oOmHDUf4MlcNV3hlHKjdmsq8ogluyt/feYqYMQQEgjxhMYZsYtpQHXrEn5/BcvtwLUvhzuTLo2GEeQNTkTOYF2STDopvxqaMUliV3iRKWuZ95DAIKsHaW30wvXrJS+vsseoKRHApRFeZJHtgA23ZheuwFNSz65VzslvAWUPLYw65oQA41WESYqac7bbkQhwiZvcsl9jguuZHyhoOP4QbRgXRoTcDozKODeZFFRw5KqnlHCMIi93x7d4toMkY8rNVh7ssXL9o/LNPFnkmViSS6aQhedGPMm26dtpPPD0fRi25MqaM+u9mzEKDXP4945QoaD4LRkV6wSsGc3NuUTY6YuveIV7X4EwAMBOJBWIpzmw1S12v44SodwJSGs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(14052099004)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dGxPTWQyYzN2ZWxmOUdlZGRqZEdiN2hwVzA3SUdEdEltMmI5NFlGTUpOYjA2?=
 =?utf-8?B?eEY0alUvME5odkFsUktlVHJoeXdzb1pVaFZ6UEpJZGd4cmtQbi84MTVwcUU0?=
 =?utf-8?B?REtldENXQWx5eGJrWHVNRlBoL2h5WVVJNXZ4Z3huQTZsVlBINVhVWUhQNzUr?=
 =?utf-8?B?UnVDTGJKMW9XWEhWc0cySkE4REdZOHEwRXNpaXRNNmtVeG1BTmxEdmQvdktp?=
 =?utf-8?B?Q0p4Q3U4MEZLMjhsNCtYRWRUeXl3R1R4M0xwdHpjeVA5Y2V0Q0NycUQ1ekxa?=
 =?utf-8?B?OExsaHZkVGRxM3kycVZnbkhQRUwvcFZMcE4vdWo3NWZ6Ung3U3hHUVB6bFN4?=
 =?utf-8?B?bEJzVUV4a0hrYlVDWjdlZ3VLRjBjQXMyQWx0SEpTNFpZQnBEYUx3YzkwWllk?=
 =?utf-8?B?VEMxaHZEU2Z0VnAyams4SGgwTkVBUjRPTFZtRzd2bzlSdUc5VHpIclkvRGpT?=
 =?utf-8?B?SnJzTWY3ZkNIQS9TcTZvNGExZXhqUFRsSUpDbENSNlFySFVXaHZqY1FhZGcx?=
 =?utf-8?B?R1hnZk9kRGdRa1E0R09iRWRuNWFVK0RDc1VlUExNaTl1L3NYNkx6ZG92VDd0?=
 =?utf-8?B?TitWd1U2Nk1yT2laTjQ0Z3ZGcC9xcVI2ZkpYa0x2MmUzcDgyZlhVUHIyZzg5?=
 =?utf-8?B?ang1ekxiZDdTc0VFTGN3VWhKQkZ2ZGpjN05FY08yZlcwTTgvT3J0aEtJZjFK?=
 =?utf-8?B?ekUwT2V1UTdpWE1ib2NrR0hpRk9sRFdqVzBhaWxTTkg4NStZM0UwOU9jdEN3?=
 =?utf-8?B?aFFOK1c1dGtoUkJLTGZNaW5Lb3hxTEorWWl1Z2ZmT09MZjgzY3ozL2Y1WVNT?=
 =?utf-8?B?c2JodHY3N2pMbm1FRTJFbUdlSlZSem1iNmsycnpLc2lSRkNRTTZHQnZ1WFRm?=
 =?utf-8?B?NVNZcXF4bzIxYzJRMnNUNTUxUGtlUGFTaHFUOHJOYklvalNTVXRuZTFWQUh6?=
 =?utf-8?B?b0Q5cDY0K09CMGlkRVp2bUtkcmo1eGJqd2Jkc3JaUDVGT21TbmFiTXRtMnBZ?=
 =?utf-8?B?REg3V0tpUHYwUDVqRVdwOFFoU2NOUU8yV281QzhFeVNub0FPaE8yZWYrT0tl?=
 =?utf-8?B?ckMvbk10VkRmNzhWWktnMFR0RU54aFFjOWpzWFRtT1lnb2NQMzl3SndhVWp5?=
 =?utf-8?B?WkhhUWVMLzcyd3hscVBKU3hpb3MveDhOM1ZiOWs5bUpIY3J5eVBnNjRBVHVU?=
 =?utf-8?B?VmZMbGFSVC83cmJMOGU3aW1Ta2FZU1lpMHRYZnoxeVJMdUgwd2E1WElsOGFE?=
 =?utf-8?B?UnZkTlRONENnN3JmRmNZMGZuUVNDSTIyaDh4T0EvbVQzN05LcWgzc1UxbmZH?=
 =?utf-8?B?UUVWNGJ6T0hxS1NBdkhqWEpSdEN5Q2FNYmJkNmhDVkhsMXc0Uk1Za1IzZXBa?=
 =?utf-8?B?MXE1cXZwbEFCRHdpNFM5ZWdoZmNKQ3diOFBwZFkwNnpSWmd4UzVaSmJuYmYy?=
 =?utf-8?B?TFh0ZTFGQVR4YnpVVDdPL3dJRUEvVzV2WHMwVzg3TlJxODdUQmpxeUdHOTEv?=
 =?utf-8?B?R3ZtbzNkeDhjSEYxT1ZDRTZ0c2ZyVTR4YzFNK1E5WFFVTHBGSHRzWElmcWU0?=
 =?utf-8?B?d25BWDBFZVRaT1NYMitTUENxdzBXcDdKRmROQmFIUklZZWxlWllUSnRXaGR2?=
 =?utf-8?B?UTYwbTlVcitJczNYYnNCVDNGbVBLVEhDdEp6OFA1aG1COEN3aWtqMEtlOXBk?=
 =?utf-8?B?Mnc5S3VwMkpEcGJHNFZOUVdUWkpnUnZsRzRvYmFEM2QycEZUbHp3QjZhZCt3?=
 =?utf-8?B?Tk13SzNZWGlpTFp0S2VFaVhieGc2YytSRERBd1hERmRpbmgxcDYvZUtZZ0xJ?=
 =?utf-8?B?ZXBleTlHK09paEoxK0V1TTBraFpRaUdpUXVsNjFsQzlSOHVyMXM2RjZLdm00?=
 =?utf-8?B?Q1hpN2tJbmxxRGFKTWh6VEt3ZWZEci9iTUdtdzNNR1lhbmVWU0VIeDJMajQ3?=
 =?utf-8?B?MzF1YllZQ1ZBcTFkNlM1czVnSlZoZHZxUEVHaHFBbVZCVnZDUU83R3FPUlNn?=
 =?utf-8?B?UlFqaWRaQlRGMENGZW9BNmkvZndLOFlLcXJ4SktqOXlHSGg1Umhvb2Ivb1Nk?=
 =?utf-8?B?ckhZTzF3eW5SZ2h3dThaNW55SUFnT0VRdEYyZWp5RXErMGY2WEZrQ3VWQlpl?=
 =?utf-8?B?czlKSWpPSHRQU0Nyb1VxUzhSQjdraU90aHB3OTNVY1Q3NHYxZU8rRkJSSlYr?=
 =?utf-8?B?K2RoNWNJNkhwU2MrUDg1K2oybkRPbExyNGo4NUlYaXlVWGZXNnBDREU1Y1FR?=
 =?utf-8?B?am41RWZKM1Y4WWdoVEU5WnNXUFVGQlhKUHgrTW5FY08wNlRuZFZGRldWWm9t?=
 =?utf-8?B?MHo2TisxazJnM0NKU243Zy9LSWNTNnR3eGJXZTFoM0FxNnlmYVU1R3ZtYlRk?=
 =?utf-8?Q?nRHkAoaDStSlA3tQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25F9C5A2A3A381409DC18693F15526C8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	v+cwWFL44aQvsI67tR3jp283XuzVQCvFq5vNKAaeZdW+L+m8q37zut06+gTLonVHJyYBmp9Yth2Uh5012VXBE97gHkGzKpRDHLwQjBqHvaHK6RhgRab6TXrIck1uiv4E/6YYWyrcMBxIpW2vo5naaCs32vrLh3+KwdUiZWamlRWSfo3Ta/iBuS05/tMqDNhu6DDmnetkxnR+jbZSnjM9g++pJR8Ked3xIhD93FhgwEAh6oiI2SCo6sq/hxKvNAYPytsp7TghuLGl/j+tq07wKzOmuP84PJ4naLl1/dUnQcqT+9hsbUX/9zVv5WyvdbMNjKMYoaoODYYKHGxg5KVi2g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OyLXum84n/Ow54OQ5zN8HjSSBweshA27yXZnCiyZYiGDYQHwvixIBLN18Jd6S53C1JMY8NdM2cf2RU6osz4xT6vIrNfisgXuHZe/1xfoRx/gxjG+CRSovYNX6AqrGTHhPZJnu8C3ep7I4Ns9gKJ29jNdUpU++gykUQDh9X3PhLy9Ea5WnitLDqRh4jUXUG9XxzM38ERhb5m3jLRBtqgAsjVlRWMu6bWKT0TUDs22cWs9Od6WHlU67fQTcLjWbjHzFitzMlx2mtwjq39Cjxl1NScVcH/ApbZ9tmemEqnFpGYwvTmJjeiLuLDnRN4MuXeUK5ntMmvhxtCW3XYxq+99HBds5N78UqFSzJsDvh1ScdD1/m0lvq9cugjMlKS0aNfz17SM7++m22p+Tp6TUwbGr4TNg4aW+ToOgGuzAyn8Z97dStJC0X7EtY5mPW62GjJbA3wnf14sIEBhhOjrHydlykFZtxoa7k6MhGfI0u/4XlSvDmL+AMidWW88KlQpwXdPfk+A39s5UsG3DGifuY1zhGgPr0UJ4sSojkYHFc+IOkFO7GJ96SSKKVj7Vq3kugIAI8vWQStZbROVp96ikiF71m8xEi48xSJVwWAKNHSY57xHuYPaUPpPVF7Y6gjyxzqy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 821525ef-8d92-4732-e612-08de7fd8e2d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2026 01:44:22.8456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UCQgjyaeykpcPGQ/K2AraPEU3PIsVe5k5tb+1GI2DIoQV64nHJpeIM2n+rInaWsnVUpL8VYrIp8X9+g5prwbVuCOazHjHna4evQ7CtjPWW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB9564

T24gTWFyIDEwLCAyMDI2IC8gMTc6MjksIFN0ZXBoZW4gWmhhbmcgd3JvdGU6DQo+IFNoaW5pY2hp
cm8gS2F3YXNha2kgPHNoaW5pY2hpcm8ua2F3YXNha2lAd2RjLmNvbT4g5LqOMjAyNuW5tDPmnIg3
5pel5ZGo5YWtIDE4OjI05YaZ6YGT77yaDQo+ID4NCj4gLi4uDQo+ID4NCj4gPiBNYXkgSSBhc2sg
eW91IHRvIHNoYXJlIHdoYXQga2luZCBvZiBkZXZpY2VzIHlvdSB1c2VkIHRvIHJlY3JlYXRlIHRo
ZSBmYWlsdXJlPw0KPiA+IEFsc28sIGNvdWxkIHlvdSBzaGFyZSB0aGUga2VybmVsIC5jb25maWcg
dG8gcmVjcmVhdGUgdGhlIGZhaWx1cmU/IEkgd291bGQgbGlrZQ0KPiA+IHVzZSB0aGVtIHRvIHJl
Y3JlYXRlIHRoZSBmYWlsdXJlIG9uIG15IHRlc3Qgc3lzdGVtLg0KPiA+DQo+IA0KPiBIbW0sIEkg
dHJpZWQgdG8gcmVwcm9kdWNlIHRoZSBpc3N1ZSBhZ2FpbiBidXQgY291bGRuJ3QuDQoNClN0ZXBo
ZW4sIHRoYW5rcy4gVGhlbiBJIHRoaW5rIHRoZSBsZWZ0IGtleSBkaWZmZXJlbmNlIGJldHdlZW4g
YmNhY2hlLzAwMSBhbmQNCnRoaXMgbmV3IGJjYWNoZS8wMDIgaXMgMTAgc2Vjb25kcyBmaW8gcmFu
ZG9tIHJlYWQuIElNTywgaXQncyB0aGUgYmV0dGVyIHRvIGRyb3ANCnRoaXMgcGF0Y2gsIGFuZCBj
cmVhdGUgYW5vdGhlciB0ZXN0IGNhc2UgdGhhdCBpbnRlbmQgdG8gZXhlcmNpc2UgYmNhY2hlIGRy
aXZlcg0KdXNpbmcgZmlvIHdvcmtsb2Fkcy4gVG8gYWRkIG1vcmUgdmFsdWUgdG8gdGhlIHRlc3Qg
Y2FzZSwgSSB0aGluayB2ZXJpZnkgd29ya2xvYWQNCmlzIHRoZSBiZXR0ZXIsIHRoYXQgd2lsbCBj
aGVjayB3cml0ZSwgcmVhZCwgYXMgd2VsbCBhcyBubyBkYXRhIGNvcnJ1cHRpb24uDQo=

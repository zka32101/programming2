# Firebase 繧｢繧ｫ繧ｦ繝ｳ繝郁ｨｭ螳・

**譖ｴ譁ｰ譌･**: 2026-06-23  
**邨ｱ荳繝｡繝ｼ繝ｫ**: `dev@gmail.com`

---

## 搭 遒ｺ隱阪Μ繧ｹ繝・

### Firebase Console 險ｭ螳・

- [ ] [Firebase Console](https://console.firebase.google.com) 縺ｫ繝ｭ繧ｰ繧､繝ｳ
  - 繝｡繝ｼ繝ｫ: `dev@gmail.com`
  - 繝代せ繝ｯ繝ｼ繝・ [菫晉ｮ｡貂医∩]

- [ ] 繝励Ο繧ｸ繧ｧ繧ｯ繝育｢ｺ隱・
  - **繝励Ο繧ｸ繧ｧ繧ｯ繝亥錐**: `your-wish-apps-9029a`
  - **繝励Ο繧ｸ繧ｧ繧ｯ繝・D**: `your-wish-apps-9029a`

- [ ] 繝励Ο繧ｸ繧ｧ繧ｯ繝郁ｨｭ螳壹〒遒ｺ隱・
  - **謇譛芽・*: `dev@gmail.com`
  - **繝｡繝ｳ繝舌・**: 蠢・ｦ√↓蠢懊§縺ｦ霑ｽ蜉

---

### google-services.json 險ｭ螳・

**迴ｾ蝨ｨ縺ｮ迥ｶ諷・*: 笨・`your-wish-apps-9029a` 縺ｫ蟇ｾ蠢・

**遒ｺ隱肴婿豕・*:
```bash
grep "package_name" android/app/google-services.json
# 譛溷ｾ・､: "com.apps.shougakukore.sansu"
```

**蠢・ｦ√↑蝣ｴ蜷医・蜀阪ム繧ｦ繝ｳ繝ｭ繝ｼ繝・*:
1. Firebase Console 竊・繝励Ο繧ｸ繧ｧ繧ｯ繝郁ｨｭ螳・
2. 縲後い繝励Μ繧定ｿｽ蜉縲坂・ Android 繧帝∈謚・
3. `com.apps.shougakukore.sansu` 繧貞・蜉・
4. google-services.json 繧偵ム繧ｦ繝ｳ繝ｭ繝ｼ繝・
5. `android/app/google-services.json` 縺ｫ荳頑嶌縺・

---

## 柏 繧ｻ繧ｭ繝･繝ｪ繝・ぅ繝√ぉ繝・け

- [ ] Firebase Authentication
  - 繝励Ο繝舌う繝: Google, Email/Password
  - 險ｱ蜿ｯ繝峨Γ繧､繝ｳ: localhost, Firebase Hosting 繝峨Γ繧､繝ｳ

- [ ] Firestore 繧ｻ繧ｭ繝･繝ｪ繝・ぅ繝ｫ繝ｼ繝ｫ
  - 譛ｬ逡ｪ繝ｫ繝ｼ繝ｫ: 繝ｦ繝ｼ繧ｶ繝ｼ隱崎ｨｼ繝吶・繧ｹ
  - 髢狗匱繝ｫ繝ｼ繝ｫ: 繝・せ繝育畑縺ｫ邱ｩ蜥鯉ｼ域悽逡ｪ蜑阪↓菫ｮ豁｣・・

- [ ] Cloud Storage 繝ｫ繝ｼ繝ｫ
  - 繝ｦ繝ｼ繧ｶ繝ｼ縺ｯ閾ｪ蛻・・繝輔ぃ繧､繝ｫ縺ｮ縺ｿ繧｢繧ｯ繧ｻ繧ｹ蜿ｯ閭ｽ

---

## 投 繝励Ο繧ｸ繧ｧ繧ｯ繝域ｧ区・

```
Firestore Collections:
笏懌楳 users/
笏・ 笏懌楳 {uid}/
笏・ 笏・ 笏懌楳 profile (蜷榊燕縲∝ｭｦ蟷ｴ縲√い繝舌ち繝ｼ)
笏・ 笏・ 笏懌楳 progress (騾ｲ謐励√せ繝医Μ繝ｼ繧ｯ)
笏・ 笏・ 笏懌楳 badges (繝舌ャ繧ｸ迯ｲ蠕怜ｱ･豁ｴ)
笏・ 笏・ 笏懌楳 coins (繧ｳ繧､繝ｳ谿矩ｫ・
笏・ 笏・ 笏披楳 characters (繧ｭ繝｣繝ｩ繧ｯ繧ｿ繝ｼ繝ｬ繝吶Ν)
笏懌楳 leaderboards/
笏懌楳 announcements/
笏披楳 config/

Cloud Functions:
笏懌楳 onUserCreated (譁ｰ隕上Θ繝ｼ繧ｶ繝ｼ蛻晄悄蛹・
笏懌楳 recordBadgeEarned (繝舌ャ繧ｸ迯ｲ蠕玲凾蜃ｦ逅・
笏披楳 updateLeaderboard (繝ｩ繝ｳ繧ｭ繝ｳ繧ｰ譖ｴ譁ｰ)

Cloud Storage:
笏披楳 /user-data/profile-pictures/{uid}/avatar.jpg
```

---

## 笨・繝・・繝ｭ繧､蜑阪メ繧ｧ繝・け

- [ ] 譛ｬ逡ｪ Firestore 繝ｫ繝ｼ繝ｫ繧定ｨｭ螳・
- [ ] Cloud Functions 繧偵ョ繝励Ο繧､
- [ ] 迺ｰ蠅・､画焚・・irebase config・峨ｒ遒ｺ隱・
- [ ] 繧ｨ繝溘Η繝ｬ繝ｼ繧ｿ縺ｧ繝・せ繝茨ｼ磯幕逋ｺ譎ゑｼ・

---

**谺｡縺ｮ繧ｹ繝・ャ繝・*: Firebase 譛ｬ險ｭ螳壹→ Cloud Functions 繝・・繝ｭ繧､



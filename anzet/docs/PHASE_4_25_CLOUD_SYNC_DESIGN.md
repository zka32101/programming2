# Phase 4.25: Cloud Sync + Multi-Device Design

**目的**: ScreenTime設定を複数デバイス間で同期 + オフラインキャッシング

---

## 📋 要件定義

### **Must機能（必須）**
- [ ] Firestore へ ScreenTime設定を保存
- [ ] 複数デバイス間で設定を同期
- [ ] オフラインモード対応（ローカルキャッシング）
- [ ] リアルタイム更新（listener）
- [ ] Conflict resolution (最終更新時刻)

### **Should機能（推奨）**
- [ ] バージョン管理 (update_version field)
- [ ] デバイスIDトラッキング
- [ ] 同期履歴ログ
- [ ] バックアップ・復元機能

### **Could機能（検討）**
- [ ] Cloud Functions で使用時間の自動集計
- [ ] Analytics への自動送信
- [ ] 保護者への通知（制限超過）

---

## 🗄️ Firestore データ構造

```
firestore/
├── users/{userId}/
│   ├── profile: { ... }
│   ├── caregivers/{caregiverId}: { ... }
│   └── children/{childId}/
│       ├── profile: { name, age, ... }
│       └── screen_time_config: {
│           dailyLimitMinutes: 120,
│           usedTodayMinutes: 45,
│           lastResetTime: Timestamp,
│           isLimitExceeded: false,
│           update_version: 3,
│           lastUpdated: Timestamp,
│           updatedByDeviceId: "device-abc123",
│           lastSyncTime: Timestamp,
│           syncStatus: "synced" | "pending" | "error"
│       }
│       └── screen_time_history: [
│           {
│               date: "2026-09-13",
│               usedMinutes: 120,
│               entries: [
│                   { startTime, endTime, durationMinutes, app }
│               ]
│           }
│       ]
```

---

## 🔐 Firestore Security Rules

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      
      match /children/{childId} {
        allow read, write: if request.auth.uid == userId;
        
        // ScreenTime Config - 親のみ読取/書き込み
        match /screen_time_config {
          allow read, write: if request.auth.uid == userId;
          
          // Validation rules
          allow write: if 
            request.resource.data.dailyLimitMinutes > 0 &&
            request.resource.data.dailyLimitMinutes <= 480 &&
            request.resource.data.usedTodayMinutes >= 0 &&
            request.resource.data.usedTodayMinutes <= 1440 &&
            request.resource.data.lastUpdated is timestamp;
        }
        
        // ScreenTime History
        match /screen_time_history/{historyDoc} {
          allow read, write: if request.auth.uid == userId;
        }
      }
    }
  }
}
```

---

## 🔄 Sync Strategy

### **1. Pull Strategy（初期化時）**
```
App Start
  → Firebase Auth Check
  → Firestore から最新 config を取得
  → Hive cache に保存
  → Provider に反映
  → リアルタイムListener 開始
```

### **2. Push Strategy（更新時）**
```
User Action (limit change, usage add)
  → Local state update
  → Provider setState
  → Hive キャッシング
  → 非同期で Firestore へ push
  → Update status: pending → synced
```

### **3. Conflict Resolution**
```
Local: v=3, lastUpdated=2026-09-13 10:00
Remote: v=4, lastUpdated=2026-09-13 10:05

→ Remote の方が新しい (10:05 > 10:00)
→ Remote を採用
→ Merge conflict なし

同一時刻の場合: deviceId の辞書順で決定
```

### **4. Offline Support**
```
Network Offline
  → Local Hive cache で動作継続
  → Pending sync queue に追加
  → UI: "同期待機中" バナー表示

Network Online
  → Pending queue を順序実行
  → Conflict check
  → Firestore へ push
  → UI: "同期完了" に更新
```

---

## 📦 実装タスク

### **タスク 4.25.1: Firestore Service 作成**
```
lib/services/firestore_screentime_service.dart
├── init() - Auth + Firestore 初期化
├── getScreenTimeConfig(userId, childId)
├── updateScreenTimeConfig(userId, childId, config)
├── subscribeToScreenTimeUpdates(userId, childId)
├── syncPendingChanges()
└── handleConflict(local, remote) → merged
```

### **タスク 4.25.2: Hive Cache Service 作成**
```
lib/services/hive_cache_service.dart
├── init() - Hive box 初期化
├── cacheScreenTimeConfig(key, config)
├── getCachedScreenTimeConfig(key)
├── getPendingSyncQueue()
├── addPendingSync(operation)
└── clearCache()
```

### **タスク 4.25.3: Cloud Sync Provider 作成**
```
lib/providers/cloud_sync_provider.dart
├── screenTimeSyncProvider (StateNotifier)
├── syncStatusProvider (enum: synced|pending|error)
├── lastSyncTimeProvider
└── offlineIndicatorProvider
```

### **タスク 4.25.4: UI 統合**
```
lib/widgets/sync_status_banner.dart
├── "同期完了" (green)
├── "同期中..." (loading)
├── "同期待機中" (orange)
└── "同期エラー" (red)
```

### **タスク 4.25.5: テスト追加**
```
test/services/firestore_screentime_service_test.dart
├── getScreenTimeConfig() → 正常系
├── updateScreenTimeConfig() → push成功
├── Conflict resolution → 正しいマージ
├── Offline → キャッシング動作
└── Network recovery → pending sync実行
```

---

## 📅 実装予定

| タスク | 工数 | 優先度 |
|---|---|---|
| **4.25.1** Firestore Service | 2h | P1 |
| **4.25.2** Hive Cache Service | 1h | P1 |
| **4.25.3** Cloud Sync Provider | 1h | P1 |
| **4.25.4** Sync Status UI | 30m | P2 |
| **4.25.5** テスト + 修正 | 1.5h | P1 |
| **合計** | **6h** | — |

---

## 🚀 Next Steps

1. **firebase_cloud_firestore** + **hive** をpubspec.yaml に追加
2. Firestore Service 実装開始
3. テスト駆動開発（TDD）で進行

---

**実装時期**: 次セッション以降 (Phase 4.25)

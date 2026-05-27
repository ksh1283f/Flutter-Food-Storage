# 🍱 반찬 관리 앱

유통기한을 놓치지 않도록 반찬을 관리하고, AI 기반 레시피를 추천받는 Flutter 앱입니다.

## 주요 기능

- **반찬 관리**: 반찬 등록, 카테고리/보관방법 분류, 유통기한 D-Day 표시
- **알림**: 유통기한 임박 반찬 로컬 푸시 알림
- **AI 레시피 추천**: 보유 재료 기반 레시피 추천 및 부족 재료 안내
- **Google 로그인**: Firebase Auth + Google Sign-In v7 (Credential Manager)
- **백엔드 연동**: Firebase ID 토큰 기반 REST API 인증

## 기술 스택

| 분류 | 사용 기술 |
|---|---|
| 프레임워크 | Flutter |
| 상태 관리 | Riverpod 2 |
| 라우팅 | go_router |
| 인증 | Firebase Auth, Google Sign-In v7 |
| 네트워크 | http (REST API) |
| 로컬 저장소 | SharedPreferences, flutter_secure_storage |
| 알림 | flutter_local_notifications |
| UI 스타일 | Cupertino (iOS-style) |

## 프로젝트 구조

```
lib/
├── core/
│   ├── router/         # go_router 라우팅 설정, auth redirect
│   └── theme/          # 색상, 텍스트 스타일, 간격 정의
├── data/
│   ├── remote/         # API 클라이언트, Auth/Recipe API
│   ├── dish_storage.dart
│   └── notification_service.dart
├── domain/
│   ├── models/         # Dish, Recipe, Enums 모델
│   └── logic/          # D-Day 계산, 카테고리 규칙, 레시피 매핑
├── presentation/
│   ├── screen/
│   │   ├── auth/       # 로그인 화면
│   │   ├── dish/       # 반찬 추가/상세 화면
│   │   ├── recipe/     # 레시피 목록/상세 화면
│   │   └── home_screen.dart
│   └── widgets/        # AppCard, DishCard, RecipeCard 등 공통 위젯
└── provider/           # Riverpod Notifier (Auth, Dish, Recipe)
```

## 시작하기

### 요구 사항

- Flutter SDK 3.x 이상
- Firebase 프로젝트 및 `google-services.json` (Android)
- Android: Google Play Store 에뮬레이터 또는 실기기 권장

### 설치

```bash
flutter pub get
flutter run
```

### Google 로그인 설정 (Android)

Google Sign-In v7은 Android Credential Manager API를 사용합니다.

1. Firebase Console에서 Android 앱의 SHA-1 지문 등록
2. `android/app/google-services.json` 최신 버전으로 교체
3. `android/app/build.gradle.kts`의 `signingConfig` 확인

> 에뮬레이터 사용 시 Google Play Store 이미지 + Google 계정 로그인 필요

## 백엔드

`https://food-storage-back.onrender.com` (REST API)

모든 요청에 Firebase ID 토큰을 `Authorization: Bearer <token>` 헤더로 전송합니다.



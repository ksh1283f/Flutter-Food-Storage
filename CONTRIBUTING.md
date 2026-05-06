# Commit Convention

[Conventional Commits](https://www.conventionalcommits.org/) 스펙을 기반으로 합니다.

## 형식

```
<type>(<scope>): <subject>

[body]

[footer]
```

- **type**, **scope**, **subject** 는 필수
- **body**, **footer** 는 선택

## Type

| Type | 설명 |
|------|------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `refactor` | 기능 변경 없는 코드 리팩토링 |
| `style` | 코드 포맷, 세미콜론 등 로직 무관한 변경 |
| `test` | 테스트 코드 추가/수정 |
| `docs` | 문서 수정 (README, CONTRIBUTING 등) |
| `chore` | 빌드 설정, 패키지 업데이트 등 기타 작업 |
| `perf` | 성능 개선 |

## Scope

변경된 기능/화면 단위로 작성합니다.

예: `auth`, `home`, `storage`, `item`, `notification`, `widget`

## Subject 규칙

- 한국어 또는 영어 통일 (프로젝트 내 일관성 유지)
- 명령형으로 작성 (`추가한다` → `추가`)
- 끝에 마침표 없음
- 50자 이내

## 예시

```
feat(storage): 식품 유통기한 등록 기능 추가

fix(item): 수량이 0일 때 삭제 버튼 비활성화 안 되는 버그 수정

refactor(home): 리스트 위젯 별도 컴포넌트로 분리

chore: cupertino_icons 버전 업데이트

docs: README 실행 방법 보완
```

## Breaking Change

하위 호환성이 깨지는 변경은 footer에 `BREAKING CHANGE:` 를 명시합니다.

```
feat(auth): 로그인 방식을 이메일에서 소셜 로그인으로 변경

BREAKING CHANGE: 기존 이메일 로그인 API 제거됨
```

# OX 리딩 워크북 메이커 (Gemini / 개인 API 키 버전)

영어 지문을 넣으면 한글 O/X 10문항 + 영어 O/X 5문항 내용일치 워크북을
만들어주는 웹사이트입니다. **사용자 각자가 자신의 Google Gemini API
키를 입력**해서 사용하므로, 운영자에게는 API 비용이 전혀 발생하지
않습니다.

## 구조

실제 로직은 `index.html` 하나뿐인 정적 페이지입니다 (API 키 입력, 문제
생성, 화면 렌더링 전부 브라우저에서 처리 — 브라우저가 사용자의 키로
구글 Gemini API를 직접 호출합니다). `server.js`와 `package.json`은
Render 같은 **Web Service**(정적 사이트 호스팅이 아닌, Node 프로세스가
떠 있어야 하는 배포 방식)에서 이 `index.html`을 서빙하기 위한 아주
가벼운 파일입니다. 외부 패키지 설치가 필요 없습니다.

## 로컬에서 확인하기

```bash
npm start
```

브라우저에서 http://localhost:3000 접속.

## Render에 Docker로 배포하기 (권장)

1. 이 폴더를 GitHub 저장소에 올립니다 (`Dockerfile`, `index.html`,
   `server.js`, `package.json`이 저장소 루트에 있어야 합니다).
2. Render 대시보드 → **New → Web Service** → 해당 저장소 연결
3. Render가 저장소에서 `Dockerfile`을 자동으로 감지합니다.
   **Runtime**이 자동으로 **Docker**로 잡히는지 확인하세요
   (수동 설정 화면에서 Language/Runtime 항목이 "Docker"로 표시되면
   Build/Start Command는 따로 입력할 필요 없습니다 — Dockerfile의
   `CMD`가 그대로 실행됩니다).
4. 별도 환경변수는 필요 없습니다.
5. Deploy 완료되면 `https://xxx.onrender.com` 주소가 생깁니다.

### 로컬에서 Docker로 확인하기 (Docker가 설치되어 있다면)

```bash
docker build -t ox-workbook .
docker run -p 3000:3000 ox-workbook
```

브라우저에서 http://localhost:3000 접속.

## Node 런타임으로 배포하기 (Dockerfile 없이, 대안)

1. 이 폴더를 GitHub 저장소에 올립니다 (`index.html`, `server.js`,
   `package.json`이 저장소 루트에 있어야 합니다).
2. Render 대시보드 → **New → Web Service** → 해당 저장소 연결
3. 설정값:
   - **Runtime**: Node
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
4. Deploy. 별도 환경변수는 필요 없습니다 (API 키는 서버가 아니라
   사용자 브라우저에서 직접 쓰입니다).
5. 완료되면 `https://xxx.onrender.com` 주소가 생깁니다 — 이 링크를
   학생들에게 공유하면 됩니다.

## 정적 사이트로도 배포 가능 (선택)

서버 프로세스가 굳이 필요 없다면 `index.html`만 GitHub Pages,
Netlify, Vercel 같은 정적 호스팅에 올려도 동일하게 동작합니다. 이
경우 Render에서는 Web Service 대신 Static Site를 선택하고 Publish
Directory를 `.`로 지정하면 됩니다.

## 사용자(학생) 입장에서 준비할 것

1. https://aistudio.google.com/apikey 에서 무료로 Gemini API 키 발급
   (구글 계정만 있으면 됨)
2. 사이트에 접속해서 발급받은 키를 입력창에 붙여넣기
3. "이 브라우저에 키 저장하기"를 체크하면 다음에 다시 입력할 필요 없음
   (그 사람의 브라우저 `localStorage`에만 저장되고, 사이트 운영자나
   다른 사람에게는 전달되지 않음)

## 알아둘 점

- API 키는 사용자의 브라우저에서 구글 서버로 **직접** 전송됩니다.
  이 사이트의 서버(Web Service로 배포한 경우에도)는 정적 HTML 파일만
  내려줄 뿐, 요청 자체를 중계하지 않으므로 키가 새어나갈 경로가
  없습니다. 다만 사용자에게 "본인의 API 키는 비밀번호처럼 다른 사람과
  공유하지 마세요"라고 안내해주세요.
- 문제 생성 모델은 `index.html` 안 `MODEL` 상수(현재
  `gemini-2.5-flash`)에서 바꿀 수 있습니다.

## 문항 생성 규칙 커스터마이즈

`index.html`의 `buildSystemPrompt()` 함수가 실제 문제 출제 규칙을
담고 있습니다. 이 규칙은 `korean-ox-workbook` Claude 스킬
(`SKILL.md` / `references/pattern_analysis.md`)의 지침을 그대로 옮긴
것이므로, 출제 스타일을 바꾸고 싶다면 두 곳을 함께 수정하세요.

# OX 리딩 워크북 메이커 (Gemini / 개인 API 키 버전)

영어 지문을 넣으면 한글 O/X 10문항 + 영어 O/X 5문항 내용일치 워크북을
만들어주는 정적(서버 없는) 웹사이트입니다. **사용자 각자가 자신의 Google
Gemini API 키를 입력**해서 사용하므로, 운영자에게는 API 비용이 전혀
발생하지 않습니다.

## 구조

파일이 `index.html` 하나뿐입니다. 서버, 빌드 과정, 환경변수 전부 필요
없습니다. 브라우저가 사용자의 키로 구글 Gemini API
(`generativelanguage.googleapis.com`)를 직접 호출합니다.

## 로컬에서 확인하기

`index.html`을 더블클릭해서 여는 것도 되지만, 일부 브라우저는 `file://`
주소에서 CORS를 더 엄격히 처리할 수 있어 정상 동작하지 않을 수 있습니다.
아래처럼 간단한 로컬 서버로 열어보는 걸 권장합니다:

```bash
npx serve .
# 또는
python3 -m http.server 8000
```

## 배포 (전부 무료로 가능)

정적 파일이므로 아무 정적 호스팅에나 올리면 됩니다:

- **GitHub Pages**: 저장소에 `index.html`을 올리고 Settings → Pages에서
  활성화
- **Netlify**: netlify.com에서 이 폴더를 드래그 앤 드롭하면 바로 배포
- **Vercel**: `vercel.com`에 이 폴더를 그대로 올리면 자동 배포

배포 후 생기는 주소(`https://xxx.github.io` 등)를 학생들에게 공유하면
됩니다.

## 사용자(학생) 입장에서 준비할 것

1. https://aistudio.google.com/apikey 에서 무료로 Gemini API 키 발급
   (구글 계정만 있으면 됨)
2. 사이트에 접속해서 발급받은 키를 입력창에 붙여넣기
3. "이 브라우저에 키 저장하기"를 체크하면 다음에 다시 입력할 필요 없음
   (그 사람의 브라우저 `localStorage`에만 저장되고, 사이트 운영자나
   다른 사람에게는 전달되지 않음)

## 알아둘 점

- Gemini API는 무료 등급(free tier)이 있어 개인이 가볍게 쓰는 데는
  대부분 비용이 들지 않습니다. 다만 각자 자신의 Google 계정 사용량
  한도 내에서 쓰는 것이므로, 사용법은 각자 안내해주는 게 좋습니다.
- API 키는 사용자의 브라우저에서 구글 서버로 **직접** 전송됩니다.
  이 사이트를 만든 사람이나 호스팅 서버를 거치지 않으므로, 키가
  새어나갈 경로 자체가 없습니다. 다만 사용자에게는 "본인의 API 키는
  비밀번호처럼 다른 사람과 공유하지 마세요"라고 안내해주세요.
- 문제 생성 모델은 `index.html` 안 `MODEL` 상수(현재
  `gemini-2.5-flash`)에서 바꿀 수 있습니다.

## 문항 생성 규칙 커스터마이즈

`index.html`의 `buildSystemPrompt()` 함수가 실제 문제 출제 규칙을
담고 있습니다. 이 규칙은 `korean-ox-workbook` Claude 스킬
(`SKILL.md` / `references/pattern_analysis.md`)의 지침을 그대로 옮긴
것이므로, 출제 스타일을 바꾸고 싶다면 두 곳을 함께 수정하세요.

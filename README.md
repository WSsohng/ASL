# ASL Website (GitHub Pages)

ASL 연구실 리뉴얼 정적 웹사이트입니다.

## Deployment

이 저장소는 `.github/workflows/deploy-pages.yml`를 통해 GitHub Pages로 배포됩니다.

1. GitHub 저장소의 **Settings > Pages**에서 Source를 **GitHub Actions**로 설정
2. `main` 브랜치에 푸시
3. Actions의 `Deploy static site to GitHub Pages` 워크플로우가 자동 배포

## Local preview

브라우저에서 `index.html`을 직접 열어 확인하거나, 간단한 정적 서버로 실행할 수 있습니다.

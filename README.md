# code-server Node.js 개발환경

- VS Code의 웹 버전을 서빙해주는 [code-server](https://coder.com/)를 통해, 완전히 격리된 Node.js 개발 환경(IDE)을 구축해줍니다.
- 로컬 환경에 VS Code 및 Node.js를 설치하지 않고도, 웹 브라우저에서 구동되는 격리된 환경의 VS Code에서, 쉽고 안전하게 Node.js 개발을 할 수 있습니다.

## 장점

- VS Code의 초기 상태는 완전히 커스터마이징할 수 있으므로, 여럿이 공동으로 개발하는 프로젝트에서 개개인의 로컬 환경 차이로 인해 일어나던 문제를 없애줍니다.
- 이를 개인 서버에 구동시켜두면 어디서든 어떤 기기로든 웹 브라우저만 있다면 바로 작업하고 커밋할 수 있습니다. 이는 [GitHub Codespaces](https://github.com/features/codespaces)와 유사합니다.

## 기본 제공 항목

- **CLI 도구**
  - Zsh, Oh My Zsh, zsh-syntax-highlighting, zsh-autosuggestions
  - Git
  - GitHub CLI
  - NVM
- **예제 소스코드**
  - redis를 사용하는 Node.js 예제 express 앱
  - prettier 구성
  - eslint 구성
- **VS Code 익스텐션**
  - `GitHub.github-vscode-theme`
  - `PKief.material-icon-theme`
  - `esbenp.prettier-vscode`
  - `dbaeumer.vscode-eslint`

## 시스템 요구사항

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
  code-server 이미지를 기반으로 커스텀 이미지를 빌드하고, docker-compose를 통해 컨테이너를 구동하기 위해서 필요합니다.
- (optional) [GitHub personal access token](https://github.com/settings/tokens)
  VS Code 내에서 `git`, `gh` 명령 및 GitHub 저장소 사용을 위해 필요합니다.

## 시작하기

1. 로컬 디렉터리에 본 저장소를 클론하고 해당 디렉터리로 이동합니다.

   ```shell
   git clone https://github.com/jeongtae/code-server-node-devenv
   cd code-server-node-devenv
   ```

2. `sample.env` 파일을 `.env` 이름의 파일로 복제합니다.

   ```shell
   cp sample.env .env
   ```

3. `.env` 파일의 빈 값을 채우고, 필요에 따라 편집합니다.
4. `docker-compose up` 명령을 통해 code-server 이미지를 빌드하고 컨테이너를 실행합니다. 이 때, `-d` 옵션을 지정하면 백그라운드에서 실행됩니다.

   ```shell
   docker-compose up --build
   ```

5. 실행된 code-server에 접속해봅니다. 기본 포트 8443을 사용하는 경우, URL은 [http://localhost:8443](http://localhost:8443) 입니다.

6. 사용을 마친 후에는, `docker-compose down` 명령을 통해 컨테이너를 제거합니다. `-v` 옵션을 지정하면 생성된 볼륨도 함께 제거됩니다.

   ```shell
   docker-compose down
   ```

## 커스터마이징

- **VS Code 익스텐션**
  `docker/code-server-extensions.txt` 파일에 VS Code Extension ID를 입력해두면, code-server 이미지가 빌드될때 해당하는 VS Code 익스텐션도 이미지에 함께 포함됩니다.
- **VS Code 전역 설정**
  `docker/code-server-settings.json` 파일은 VS Code 전역 설정 파일입니다. 스니펫은 `docker/code-server-snippets/` 디렉터리에 저장되며, 키 설정은 `docker/code-server-keybindings.json` 파일에 저장됩니다.
- **VS Code 개인 설정**
  VS Code 내에서의 Workspace 설정을 통해 개인 설정을 합니다. 이 내용은 .vscode 디렉터리 내에 저장되고, Git에게서 무시됩니다. **전역 설정**에는 공동 작업자들에게도 적용할 설정을 구성하고, 테마 등과 같은 개인적인 설정은 Git이 이력추적을 하지 않는 **개인 설정**에서 구성하는 것이 좋습니다.
- **Node.js 버전**
  Node.js는 NVM을 통해 설치되며, 버전은 `.env` 파일에서 `NODE_VERSION` 키를 통해 지정합니다.
- **GitHub 로그인**
  `.env` 파일에 설정된 `GH_TOKEN` 값으로 GitHub에 인증하여 git 작업을 할 수 있게 구성되어있습니다. SSH 등의 다른 인증수단은 따로 구성해야 합니다.
- **추가 Docker 컨테이너**
  code-server 외에 다른 Docker 컨테이너(postgres 등)가 필요하다면, `docker-compose.yml` 파일에서 설정하면 됩니다.

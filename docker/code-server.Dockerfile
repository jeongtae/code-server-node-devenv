FROM linuxserver/code-server:latest

# install Zsh
RUN apt update && apt install -y zsh && chsh -s $(which zsh) abc;
SHELL ["/bin/zsh", "-c"]

# install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";

# install Zsh plugins
RUN sh -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
RUN sh -c "git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
RUN cat /config/.zshrc | sed -E 's/(^plugins=.+)\)/\1 zsh-syntax-highlighting zsh-autosuggestions)/g' > /config/.zshrc

# append setup script into .zshrc to setup Git profile
RUN echo "git config --global user.name ${GIT_USERNAME} && git config --global user.email ${GIT_EMAIL}" >> /config/.zshrc

# install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
RUN apt update && apt install gh

# install NVM
ARG NVM_VERSION
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash

# install Node
ARG NODE_VERSION
RUN . /config/.zshrc && nvm install ${NODE_VERSION}

# install code-server extensions
COPY ["code-server-extensions.txt", "/"]
RUN if [ ! -z "$(xargs < /code-server-extensions.txt)" ]; then \
      /app/code-server/bin/code-server --extensions-dir /config/extensions \
      $(xargs < /code-server-extensions.txt | sed -E 's/(\s|^)(\S)/ --install-extension \2/g'); \
    fi; rm /code-server-extensions.txt

# expose ports
EXPOSE 8443
EXPOSE 3000

FROM oraclelinux:9

#
# Identify the maintainer of an image
LABEL maintainer="madperro@gmail.com"

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

RUN yum check-update; \
    yum install -y gcc libffi-devel python3 python3-pip epel-release; \
    yum install -y openssh-clients git sudo yum-utils

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support in the last two lines
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN python3 -m pip install --upgrade pip; \
    python3 -m pip install "ansible==8.1.0"

RUN dnf install https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell-7.4.1-1.rh.x86_64.rpm; \
    pwsh -c "\$ProgressPreference = 'SilentlyContinue'; Install-Module -Name Az -RequiredVersion 10.1.0 -Force"; \
    rpm --import https://packages.microsoft.com/keys/microsoft.asc; \
    dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm; \
    dnf install azure-cli; \
    python3 -m pip install ansible[azure];

# Install latest kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install latest terraform
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
    && yum -y install terraform

RUN echo "export PS1='[\\u@docker \\W]\\$ '" >> "/home/$USERNAME/.bash_profile"

# Persist bash history
# https://code.visualstudio.com/remote/advancedcontainers/persist-bash-history
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory \
    && echo "$SNIPPET" >> "/home/$USERNAME/.bashrc"

# Add bash autocompletion
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#optional-kubectl-configurations-and-plugins
RUN yum install bash-completion \
    && echo "source /usr/share/bash-completion/bash_completion" >> "/home/$USERNAME/.bashrc" \
    && echo "source <(kubectl completion bash)" >> "/home/$USERNAME/.bashrc" \
    && echo "alias k=kubectl" >> "/home/$USERNAME/.bashrc" \
    && echo "complete -o default -F __start_kubectl k" >> "/home/$USERNAME/.bashrc"

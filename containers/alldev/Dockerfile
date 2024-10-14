FROM oraclelinux:9

#
# Identify the maintainer of an image
LABEL maintainer="sebastian.szuber@nordcloud.com"

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

RUN yum check-update; \
    yum install -y gcc libffi-devel python3 python3-pip epel-release; \
    yum install -y openssh-clients git sudo yum-utils; \
    yum install -y bind-utils

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support in the last two lines
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# RUN python3 -m pip install --upgrade pip; \
#     python3 -m pip install "ansible==8.1.0"

RUN python3 -m pip install --upgrade pip

# RUN dnf install https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell-7.4.1-1.rh.x86_64.rpm; \
#     pwsh -c "\$ProgressPreference = 'SilentlyContinue'; Install-Module -Name Az -RequiredVersion 10.1.0 -Force"; \
#     rpm --import https://packages.microsoft.com/keys/microsoft.asc; \
#     dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm; \
#     dnf install azure-cli; \
#     python3 -m pip install ansible[azure];

# Install PowerShell Core
ARG PS_VERSION=7.4.2
RUN dnf install https://github.com/PowerShell/PowerShell/releases/download/v$PS_VERSION/powershell-$PS_VERSION-1.rh.x86_64.rpm

# RUN pwsh -c "\$ProgressPreference = 'SilentlyContinue'; Install-Module -Name Az -Force"

# Install Azure CLI
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc; \
    dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm; \
    dnf install azure-cli

# Install latest kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh

# Install latest terraform
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
    && yum -y install terraform

# Set PS1
RUN echo "export PS1='[\\u@docker \\W]\\$ '" >> "/home/$USERNAME/.bash_profile"
# Add Krew to the PATH
RUN echo "export PATH=""\${PATH}:/home/$USERNAME/.krew/bin""" >> "/home/$USERNAME/.bash_profile"

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


USER $USERNAME:$USERNAME

# Install Krew
ARG KREW_VERSION=0.4.4
RUN set -x; cd "$(mktemp -d)" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v$KREW_VERSION/krew-linux_amd64.tar.gz" && \
    tar zxvf krew-linux_amd64.tar.gz && \
    KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" && \
    "$KREW" install krew

# RUN export PATH="${PATH}:/home/$USERNAME/.krew/bin" && kubectl krew install ingress-nginx

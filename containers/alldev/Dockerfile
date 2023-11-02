FROM oraclelinux:9

#
# Identify the maintainer of an image
LABEL maintainer="madperro@gmail.com"

RUN yum check-update; \
    yum install -y gcc libffi-devel python3 python3-pip epel-release; \
    yum install -y openssh-clients; \
    python3 -m pip install --upgrade pip; \
    python3 -m pip install "ansible==8.1.0"

RUN dnf install https://github.com/PowerShell/PowerShell/releases/download/v7.3.5/powershell-7.3.5-1.rh.x86_64.rpm; \
    pwsh -c "\$ProgressPreference = 'SilentlyContinue'; Install-Module -Name Az -RequiredVersion 10.1.0 -Force"; \
    rpm --import https://packages.microsoft.com/keys/microsoft.asc; \
    dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm; \
    dnf install azure-cli; \
    python3 -m pip install ansible[azure];

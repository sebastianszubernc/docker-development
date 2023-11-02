FROM oraclelinux:9

RUN yum check-update; \
    yum install -y gcc libffi-devel python3 python3-pip epel-release; \
    yum install -y openssh-clients; \
    python3 -m pip install --upgrade pip; \
    python3 -m pip install "ansible==8.1.0"

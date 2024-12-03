
#FROM registry.access.redhat.com/ubi8
FROM registry.access.redhat.com/ubi8@sha256:a965f33ee4ee57dc8e40a1f9350ddf28ed0727b6cf80db46cdad0486a7580f9d
RUN yum -y update
RUN yum -y install sudo procps-ng hostname vim-common file bc
RUN yum clean all
RUN chmod 0666 /etc/sudoers
RUN sed -i -e "s+^%wheel+##%wheel+" -e "s+^# %wheel+%wheel+" /etc/sudoers
RUN chmod 0440 /etc/sudoers
RUN useradd -G wheel -M test
CMD [ "/bin/bash" ]


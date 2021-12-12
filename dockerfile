FROM archlinux:latest

RUN pacman -Syyu --noconfirm qtcreator cmake python-pip clang base-devel && \
    find /var/cache/pacman/ -type f -delete

RUN pip install conan

RUN groupadd -r user && useradd -r -g user user
RUN mkdir -p /home/user

RUN mkdir -p /home/user/.config/QtProject/qtcreator/templates/wizards/projects/cpp/
COPY . /home/user/.config/QtProject/qtcreator/templates/wizards/projects/cpp/
RUN echo -e '[General]\nWelcome2Tab=Develop' > /home/user/.config/QtProject/QtCreator.ini

# workaround
RUN ln -s /home/user/.config/QtProject /usr/share/qtcreator/QtProject

RUN chown -R user:user /home/user

USER user

CMD ["qtcreator"]

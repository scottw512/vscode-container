FROM python:3.4

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY . .

RUN apt-get update && apt-get install -y xauth x11-apps 
RUN apt install -y software-properties-common apt-transport-https curl

RUN wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add
RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
RUN apt update && apt install -y dotnet-sdk-3.1 aspnetcore-runtime-3.1
RUN apt update && apt install -y code
RUN apt update && apt install -y libasound2-dev

RUN apt update && apt install -y gconf2 gconf-service gvfs-bin xdg-utils
RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
RUN echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
RUN apt update && apt install -y sublime-text


EXPOSE 8085 5900
CMD ["python", "manage.py", "runserver", "0.0.0.0:8001"]
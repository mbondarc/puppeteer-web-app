FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ADD Files/FontsToAdd.tar /Fonts/

WORKDIR /Fonts/
RUN .\\Add-Font.ps1 Fonts/

WORKDIR /
RUN Remove-Item Fonts -Recurse

ENV NODE_VERSION 10.16.3

RUN Invoke-WebRequest $('https://nodejs.org/dist/v{0}/node-v{0}-win-x64.zip' -f $env:NODE_VERSION) -OutFile 'node.zip' -UseBasicParsing ; \
    Expand-Archive node.zip -DestinationPath C:\ ; \
    Rename-Item -Path $('C:\node-v{0}-win-x64' -f $env:NODE_VERSION) -NewName 'C:\nodejs'

USER ContainerAdministrator
RUN [Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\nodejs', 'Machine')

RUN New-Item -ItemType directory -Path C:\app
WORKDIR /app

COPY . .

RUN npm install

EXPOSE 8000
CMD [ "node.exe", "server.js" ]
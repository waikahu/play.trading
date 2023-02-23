FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5006

ENV ASPNETCORE_URLS=http://+:5006

RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
COPY ["src/Play.Trading.Service/Play.Trading.Service.csproj", "src/Play.Trading.Service/"]

RUN --mount=type=secret,id=GH_OWNER,dst=/GH_OWNER --mount=type=secret,id=GH_PAT,dst=/GH_PAT \
    dotnet nuget add source --username USERNAME --password `cat /GH_PAT` --store-password-in-clear-text --name github "https://nuget.pkg.github.com/`cat /GH_OWNER`/index.json"

RUN dotnet restore "src/Play.Trading.Service/Play.Trading.Service.csproj"
COPY ./src ./src
WORKDIR "/src/Play.Trading.Service"
RUN dotnet publish "Play.Trading.Service.csproj" -c Release --no-restore -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Play.Trading.Service.dll"]

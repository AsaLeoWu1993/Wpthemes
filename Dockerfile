#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["Wpthemes/Wpthemes.csproj", "Wpthemes/"]
RUN dotnet restore "Wpthemes/Wpthemes.csproj"
COPY . .
WORKDIR "/src/Wpthemes"
RUN dotnet build "Wpthemes.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Wpthemes.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Wpthemes.dll"]
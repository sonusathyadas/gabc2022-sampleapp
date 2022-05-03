#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["*.csproj", "./"]
RUN dotnet restore 
COPY . .
RUN dotnet build  

FROM build AS publish
RUN dotnet publish  -c Release -o /publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
EXPOSE 80
EXPOSE 443
WORKDIR /app
COPY --from=publish /publish .
ENTRYPOINT ["dotnet", "SampleMVCWeb.dll"]
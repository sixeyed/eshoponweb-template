FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build

WORKDIR /src
COPY ./src/ApplicationCore/ApplicationCore.csproj ./ApplicationCore/
COPY ./src/Infrastructure/Infrastructure.csproj ./Infrastructure/
COPY ./src/Web/Web.csproj ./Web/
RUN dotnet restore ./Web/Web.csproj

COPY ./src/ .
WORKDIR /src/Web
RUN dotnet publish -c Release -o /app

# unit tests
FROM build as unit-test

WORKDIR /tests
COPY ./tests/UnitTests/UnitTests.csproj ./UnitTests/
RUN dotnet restore ./UnitTests/UnitTests.csproj

COPY ./tests/UnitTests/ ./UnitTests/
WORKDIR /tests/UnitTests
RUN dotnet test UnitTests.csproj

# app image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2

EXPOSE 80
WORKDIR /app
ENTRYPOINT ["dotnet", "Web.dll"]

COPY --from=build /app .

#!/usr/bin/env bash

# Build project
dotnet build LogicAnalyzer/LogicAnalyzer.csproj -c Release

# Copy over decoders
cp -r ../decoders LogicAnalyzer/bin/Release/net8.0/

#!/bin/sh
set -ef
exec workspace-mcp --transport streamable-http --single-user --tools ${WORKSPACE_MCP_TOOLS}

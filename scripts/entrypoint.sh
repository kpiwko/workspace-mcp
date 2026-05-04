#!/bin/sh
set -ef
exec workspace-mcp --transport streamable-http --tools ${WORKSPACE_MCP_TOOLS}

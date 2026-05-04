#!/bin/sh
set -e
exec workspace-mcp --transport streamable-http --tools ${WORKSPACE_MCP_TOOLS}

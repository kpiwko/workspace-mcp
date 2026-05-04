FROM registry.access.redhat.com/ubi9/python-312:latest

LABEL name="workspace-mcp" \
      summary="Google Workspace MCP Server" \
      description="MCP server providing Google Workspace access via workspace-mcp (Gmail, Drive, Calendar, Docs, Sheets, Slides, Forms, Apps Script)" \
      maintainer="kpiwko@redhat.com"

USER root

RUN pip install --upgrade pip \
    && pip install workspace-mcp

ENV WORKSPACE_MCP_CREDENTIALS_DIR=/root/.config/workspace-mcp \
    WORKSPACE_MCP_TOOLS="gmail drive calendar docs sheets slides forms appscript" \
    WORKSPACE_MCP_PORT=8000 \
    WORKSPACE_MCP_HOST=0.0.0.0

VOLUME ["/root/.config/workspace-mcp"]

EXPOSE 8000

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]

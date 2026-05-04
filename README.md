# workspace-mcp

A UBI9 container wrapping the [`workspace-mcp`](https://pypi.org/project/workspace-mcp/) PyPI package (v1.20.3), providing an HTTP MCP server for Google Workspace: Gmail, Drive, Calendar, Docs, Sheets, Slides, Forms, and Apps Script.

Published as `ghcr.io/kpiwko/workspace-mcp:latest`.

## Ports

| Host port | Container port | Endpoint |
|-----------|---------------|----------|
| 17150 | 8000 | `http://localhost:17150/mcp` |

## Google Cloud Setup (one-time)

1. Open the [Google Cloud Console](https://console.cloud.google.com/) and select or create a project. An existing project (e.g. from a previous `gmail-mcp` setup) can be reused.

2. Enable these eight APIs:
   - Gmail API
   - Google Drive API
   - Google Calendar API
   - Google Docs API
   - Google Sheets API
   - Google Slides API
   - Google Forms API
   - Apps Script API

3. Create an OAuth 2.0 credential. Under **APIs & Services > Credentials**, click **Create Credentials > OAuth client ID** and choose **Web application** (not Desktop app).

4. Add the following URI under **Authorized redirect URIs**:
   ```
   http://localhost:17150/oauth2callback
   ```

5. Copy the generated **Client ID** and **Client Secret** into your `.env` file:
   ```bash
   GOOGLE_OAUTH_CLIENT_ID=<your-client-id>
   GOOGLE_OAUTH_CLIENT_SECRET=<your-client-secret>
   ```

## First-Run Authentication

```bash
mkdir -p ~/.config/workspace-mcp
podman compose up -d workspace-mcp
open http://localhost:17150/
```

Complete the OAuth browser flow. The refresh token is saved automatically to `~/.config/workspace-mcp` and reused on subsequent container restarts.

## Token Refresh

If authentication fails, re-run the OAuth flow without stopping the container:

```bash
open http://localhost:17150/
```

## MCP Registration

```bash
claude mcp add --transport http --scope user workspace-mcp http://localhost:17150/mcp
```

## Configuring Tools

The `WORKSPACE_MCP_TOOLS` environment variable controls which tools are exposed. The default set is `gmail drive calendar docs sheets slides forms appscript` (`appscript` is the workspace-mcp tool name for Google Apps Script).

Override in `compose.yaml` to restrict the set:
```yaml
environment:
  WORKSPACE_MCP_TOOLS: "gmail drive calendar"
```

## compose.yaml

```yaml
workspace-mcp:
  image: ghcr.io/kpiwko/workspace-mcp:latest
  networks: [ai-stack]
  ports:
    - "17150:8000"
  volumes:
    - /Users/kpiwko/.config/workspace-mcp:/root/.config/workspace-mcp
  environment:
    GOOGLE_OAUTH_CLIENT_ID: ${GOOGLE_OAUTH_CLIENT_ID}
    GOOGLE_OAUTH_CLIENT_SECRET: ${GOOGLE_OAUTH_CLIENT_SECRET}
  restart: unless-stopped
```

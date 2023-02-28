import tomllib

from fastapi import APIRouter, FastAPI, HTTPException
from fastapi.responses import JSONResponse, RedirectResponse
from starlette.responses import FileResponse

with open("config.toml", "rb") as f:
    config = tomllib.load(f)


class DocsServer:
    def __init__(self):
        self.router = APIRouter()
        self.router.add_api_route("/", self.root, response_class=RedirectResponse)
        self.router.add_api_route("/routes", self.routes, response_class=JSONResponse)
        self.router.add_api_route("/healthz", self.healthz, response_class=JSONResponse)
        self.router.add_api_route("/{path:path}", self.docs, response_class=FileResponse)
        self.root_redirect = config["general"]["root_redirect_path"]

    def root(self) -> RedirectResponse:
        return RedirectResponse(url=self.root_redirect)

    def healthz(self) -> JSONResponse:
        return JSONResponse({"ready": True})

    def routes(self) -> JSONResponse:
        return JSONResponse({"routes": list(config["routes"].keys())})

    def docs(self, path: str) -> FileResponse:
        path = path.rstrip("/")
        if path not in config["routes"]:
            raise HTTPException(status_code=404, detail="Path not found")
        return FileResponse(f"/app/{config['routes'][path]}")


app = FastAPI()
server = DocsServer()
app.include_router(server.router)

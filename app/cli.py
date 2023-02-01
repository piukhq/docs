import click
import uvicorn


@click.group()
def cli():
    pass


@cli.command(name="serve")
@click.option("-h", "--host", default="0.0.0.0", help="Host to bind to", show_default=True)
@click.option("-p", "--port", default=6502, help="HTTP Port to use", show_default=True)
def serve(port: int, host: str):
    uvicorn.run("app.main:app", host=host, port=port)


if __name__ == "__main__":
    cli()

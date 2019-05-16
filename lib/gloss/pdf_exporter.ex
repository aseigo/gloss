defmodule Gloss.PdfExporter do
  use GenServer

  def generate(), do: GenServer.cast(__MODULE__, :generate)
  def relative_path(), do: "/pdf/glossary.pdf"
  def url(), do:  GlossWeb.Router.Helpers.static_url(GlossWeb.Endpoint, relative_path())

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    {:ok, :pdf, {:continue, :generate}}
  end

  @impl GenServer
  def handle_continue(:generate, state) do
    generate()
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast(:generate, state) do
    gen_path = Gloss.Glossary.export()
    target_path = Path.join([:code.priv_dir(:gloss), "static", relative_path()])
    target_path |> Path.dirname() |> File.mkdir_p()
    case File.rename(gen_path, target_path) do
      {:error, _} ->
        File.cp(gen_path, target_path)
        File.rm(gen_path)

      _ -> :ok
    end
    {:noreply, state}
  end
end

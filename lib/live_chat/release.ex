
defmodule LiveChat.Release do
  @app :live_chat
  use GenServer

  defp start_app do
    load_app()
    Application.put_env(@app, :minimal, true)
    Application.ensure_all_started(@app)
    # redeploy
  end

  def create do
    load_app()

    for repo <- repos() do
      case repo.__adapter__.storage_up(repo.config) do
        :ok -> IO.inspect("#{inspect(repo)} created created")
        {:error, :already_up} -> IO.inspect("#{inspect(repo)}  already created")
        {:error, term} -> IO.inspect("#{inspect(repo)}  failed #{inspect(term)}")
      end
    end
  end

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end

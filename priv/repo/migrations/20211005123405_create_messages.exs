defmodule LiveChat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :chat_id, :string
      add :message, :text
      add :author, :string

      timestamps()
    end

  end
end

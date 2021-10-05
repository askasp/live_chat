defmodule LiveChat.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :author, :string
    field :chat_id, :string
    field :message, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:chat_id, :message, :author])
    |> validate_required([:chat_id, :message, :author])
  end
end

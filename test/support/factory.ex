defmodule UtilityBelt.Factory do
  @moduledoc """
  factory for test data
  """
  use ExMachina
  alias Ecto.UUID
  alias Faker.{NaiveDateTime, Name}

  def user_factory do
    %{
      id: UUID.generate(),
      name: Name.name(),
      gender: Enum.random(["F", "M", "U"]),
      age: Enum.random(25..37),
      inserted_at: NaiveDateTime.backward(20),
      updated_at: NaiveDateTime.backward(1)
    }
  end
end

defmodule UtilityBelt.Db.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias UtilityBelt.Db.Schema.User

  @primary_key false
  schema "user" do
    field(:id, :binary_id, primary_key: true, null: false)
    field(:username, :string, null: false)

    timestamps()
  end

  def insert_changeset(params) do
    User
    |> struct()
    |> cast(params, [:id, :username])
    |> validate_required([:id, :username])
  end

  def update_changeset(params, data \\ User) do
    data
    |> struct()
    |> cast(params, [:id, :username])
  end
end

defmodule UtilityBelt.Db.Repo do
  @moduledoc false
  alias UtilityBelt.Db.Schema.User
  def one(_), do: nil
  def all(_), do: nil
  def insert(changeset), do: {:ok, changeset.changes}
  def insert(changeset, _opts), do: {:ok, changeset.changes}
  def update(changeset), do: {:ok, changeset.changes}
  def delete(changeset), do: {:ok, changeset.changes}
  def get_by(_schema, _opts), do: %User{id: 1, username: "tyr"}
end

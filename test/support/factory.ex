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

defmodule UtilityBelt.Db.Repo.TestUser do
  @moduledoc false
  def one(_), do: nil
  def all(_), do: nil
end

defmodule ProjectUtilsTest do
  use ExUnit.Case
  alias UtilityBelt.ProjectUtils

  test "get project top shall not raise any issue" do
    assert ProjectUtils.get() != ""
  end
end
